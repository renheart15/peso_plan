<?php

namespace App\Services;

use App\Models\DeviceToken;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * Sends Firebase Cloud Messaging (FCM) v1 HTTP push notifications.
 *
 * Uses the FCM HTTP v1 API with a server key stored in config/services.php
 * under  services.fcm.server_key  (set FCM_SERVER_KEY in .env).
 *
 * Message data can include a `route` key so the Flutter app can deep-link
 * directly to the relevant screen when the notification is tapped.
 */
class FcmService
{
    private const FCM_ENDPOINT = 'https://fcm.googleapis.com/fcm/send';

    private string $serverKey;

    public function __construct()
    {
        $this->serverKey = config('services.fcm.server_key', '');
    }

    // ── Public API ────────────────────────────────────────────────

    /**
     * Send a notification to every device token belonging to a user.
     *
     * @param  int         $userId
     * @param  string      $title
     * @param  string      $body
     * @param  array<string,mixed>  $data   Extra key-value pairs sent in the data payload.
     *                                       Add `'route' => '/dashboard'` to deep-link on tap.
     */
    public function sendToUser(
        int $userId,
        string $title,
        string $body,
        array $data = []
    ): void {
        $tokens = DeviceToken::where('user_id', $userId)
            ->pluck('token')
            ->all();

        foreach ($tokens as $token) {
            $this->sendToToken($token, $title, $body, $data);
        }
    }

    /**
     * Send a notification to every member of a household except the sender.
     */
    public function sendToHousehold(
        int $householdId,
        string $title,
        string $body,
        array $data = [],
        ?int $excludeUserId = null
    ): void {
        $query = DeviceToken::whereHas('user.households', fn ($q) => $q->where('households.id', $householdId));

        if ($excludeUserId !== null) {
            $query->where('user_id', '!=', $excludeUserId);
        }

        $tokens = $query->pluck('token')->all();

        foreach ($tokens as $token) {
            $this->sendToToken($token, $title, $body, $data);
        }
    }

    /**
     * Send to a single FCM registration token.
     */
    public function sendToToken(
        string $token,
        string $title,
        string $body,
        array $data = []
    ): void {
        if (empty($this->serverKey)) {
            Log::debug('[FCM] Server key not configured — notification skipped.', compact('title', 'body'));
            return;
        }

        $payload = [
            'to'           => $token,
            'notification' => [
                'title' => $title,
                'body'  => $body,
                'sound' => 'default',
            ],
            'data'         => array_merge($data, ['click_action' => 'FLUTTER_NOTIFICATION_CLICK']),
            'priority'     => 'high',
        ];

        try {
            $response = Http::withHeaders([
                'Authorization' => 'key=' . $this->serverKey,
                'Content-Type'  => 'application/json',
            ])->post(self::FCM_ENDPOINT, $payload);

            if (!$response->successful()) {
                Log::warning('[FCM] Delivery failed', [
                    'status' => $response->status(),
                    'body'   => $response->body(),
                    'token'  => substr($token, 0, 20) . '...',
                ]);
            }
        } catch (\Throwable $e) {
            Log::error('[FCM] Exception sending notification', ['error' => $e->getMessage()]);
        }
    }
}
