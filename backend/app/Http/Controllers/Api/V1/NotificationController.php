<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Household;
use App\Services\FcmService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Allows authenticated users (owner/partner) to send push notifications
 * to other members of their household.
 *
 * POST /api/v1/households/{household}/notifications/send
 *
 * Body:
 *   title   string  required  Notification title
 *   body    string  required  Notification body
 *   route   string  optional  Deep-link route (e.g. /budget, /goals)
 */
class NotificationController extends Controller
{
    public function __construct(private readonly FcmService $fcm) {}

    public function send(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->isMember($request->user()), 403, 'Not a household member.');

        $validated = $request->validate([
            'title' => ['required', 'string', 'max:100'],
            'body'  => ['required', 'string', 'max:255'],
            'route' => ['nullable', 'string', 'max:100'],
        ]);

        $data = [];
        if (!empty($validated['route'])) {
            $data['route'] = $validated['route'];
        }

        $this->fcm->sendToHousehold(
            householdId: $household->id,
            title:       $validated['title'],
            body:        $validated['body'],
            data:        $data,
            excludeUserId: $request->user()->id,
        );

        return response()->json(['message' => 'Notification sent.']);
    }
}

