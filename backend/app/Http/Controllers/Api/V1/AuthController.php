<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\ForgotPasswordRequest;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Http\Requests\Auth\ResetPasswordRequest;
use App\Models\Household;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Laravel\Sanctum\PersonalAccessToken;

class AuthController extends Controller
{
    /**
     * Register a new user and create their first household.
     */
    public function register(RegisterRequest $request): JsonResponse
    {
        $user = DB::transaction(function () use ($request) {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
            ]);

            // Create first household
            $household = Household::create([
                'name' => $request->household_name,
                'owner_id' => $user->id,
            ]);

            // Add user as owner member
            $household->members()->attach($user->id, ['role' => 'owner']);

            // Set as current household
            $user->update(['current_household_id' => $household->id]);

            // Send email verification
            $user->sendEmailVerificationNotification();

            return $user;
        });

        $token = $user->createToken($request->device_name)->plainTextToken;

        return response()->json([
            'token' => $token,
            'is_first_login' => true,
            'user' => $this->userPayload($user),
        ], 201);
    }

    /**
     * Login with email + password, returns a Sanctum personal access token.
     */
    public function login(LoginRequest $request): JsonResponse
    {
        if (! Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['message' => 'Invalid credentials.'], 401);
        }

        /** @var User $user */
        $user = Auth::user();
        $token = $user->createToken($request->device_name)->plainTextToken;

        return response()->json([
            'token' => $token,
            'is_first_login' => false,
            'user' => $this->userPayload($user),
        ]);
    }

    /**
     * Revoke the current token (logout). Optionally removes a device token.
     */
    public function logout(Request $request): JsonResponse
    {
        if ($deviceToken = $request->input('device_token')) {
            $request->user()->deviceTokens()->where('token', $deviceToken)->delete();
        }

        $accessToken = $request->user()->currentAccessToken();
        if ($accessToken instanceof PersonalAccessToken) {
            $accessToken->delete();
        }

        return response()->json(['message' => 'Logged out.']);
    }

    /**
     * Return the authenticated user's profile.
     */
    public function me(Request $request): JsonResponse
    {
        return response()->json(['data' => $this->userPayload($request->user())]);
    }

    /**
     * Send a password reset link email.
     */
    public function forgotPassword(ForgotPasswordRequest $request): JsonResponse
    {
        Password::sendResetLink($request->only('email'));

        // Always return success to prevent email enumeration.
        return response()->json(['message' => 'If that email exists, a reset link has been sent.']);
    }

    /**
     * Reset the user's password using a valid token.
     */
    public function resetPassword(ResetPasswordRequest $request): JsonResponse
    {
        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function (User $user, string $password) {
                $user->forceFill(['password' => Hash::make($password)])->save();
                $user->tokens()->delete(); // invalidate all existing tokens
            }
        );

        if ($status !== Password::PASSWORD_RESET) {
            return response()->json(['message' => __($status)], 422);
        }

        return response()->json(['message' => 'Password has been reset.']);
    }

    /**
     * Resend the email verification notification.
     */
    public function resendVerification(Request $request): JsonResponse
    {
        if ($request->user()->hasVerifiedEmail()) {
            return response()->json(['message' => 'Email already verified.']);
        }

        $request->user()->sendEmailVerificationNotification();

        return response()->json(['message' => 'Verification email sent.']);
    }

    // ── Private helpers ───────────────────────────────────────────

    private function userPayload(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'email_verified_at' => $user->email_verified_at,
            'current_household_id' => $user->current_household_id,
        ];
    }
}
