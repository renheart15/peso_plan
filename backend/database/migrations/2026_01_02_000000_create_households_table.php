<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('households', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->foreignId('owner_id')->constrained('users')->cascadeOnDelete();
            $table->timestamps();
        });

        Schema::create('household_members', function (Blueprint $table) {
            $table->id();
            $table->foreignId('household_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('role', ['owner', 'partner', 'viewer'])->default('viewer');
            $table->timestamps();

            $table->unique(['household_id', 'user_id']);
        });

        // Add current_household_id to users
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('current_household_id')
                ->nullable()
                ->after('remember_token')
                ->constrained('households')
                ->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeignIdFor(null, 'current_household_id');
            $table->dropColumn('current_household_id');
        });
        Schema::dropIfExists('household_members');
        Schema::dropIfExists('households');
    }
};
