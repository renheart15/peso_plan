<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_and_receive_a_token(): void
    {
        $response = $this->postJson('/api/v1/auth/register', [
            'name' => 'Peso Owner',
            'email' => 'owner@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'household_name' => 'Alfanta Household',
            'device_name' => 'Test Device',
        ]);

        $response->assertCreated()
            ->assertJsonPath('is_first_login', true)
            ->assertJsonPath('user.email', 'owner@example.com')
            ->assertJsonStructure(['token', 'user']);

        $this->assertDatabaseHas('users', ['email' => 'owner@example.com']);
        $this->assertDatabaseHas('households', ['name' => 'Alfanta Household']);
    }

    public function test_user_can_login_with_valid_credentials(): void
    {
        User::factory()->create([
            'email' => 'login@example.com',
            'password' => Hash::make('password123'),
        ]);

        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'login@example.com',
            'password' => 'password123',
            'device_name' => 'Test Device',
        ]);

        $response->assertOk()
            ->assertJsonPath('user.email', 'login@example.com')
            ->assertJsonStructure(['token', 'user']);
    }

    public function test_invalid_login_is_rejected(): void
    {
        $this->postJson('/api/v1/auth/login', [
            'email' => 'missing@example.com',
            'password' => 'wrong-password',
            'device_name' => 'Test Device',
        ])->assertUnauthorized();
    }

    public function test_authenticated_user_can_read_profile_and_logout(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $this->getJson('/api/v1/auth/me')
            ->assertOk()
            ->assertJsonPath('data.email', $user->email);

        $this->postJson('/api/v1/auth/logout')->assertOk();
    }
}
