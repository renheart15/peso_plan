<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DeviceTokenController extends Controller
{
    /**
     * Register an FCM device token for the authenticated user.
     *
     * Upserts by token value so registering the same device twice is idempotent.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'token' => ['required', 'string', 'max:255'],
            'platform' => ['required', 'string', 'in:android,ios'],
        ]);

        $deviceToken = $request->user()->deviceTokens()->updateOrCreate(
            ['token' => $validated['token']],
            ['platform' => $validated['platform']]
        );

        return response()->json(['data' => $deviceToken], $deviceToken->wasRecentlyCreated ? 201 : 200);
    }

    /**
     * Remove a device token (on logout or token refresh).
     */
    public function destroy(Request $request, string $token): JsonResponse
    {
        $request->user()
            ->deviceTokens()
            ->where('token', $token)
            ->delete();

        return response()->json(null, 204);
    }
}
