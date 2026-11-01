<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('budgets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('household_id')->constrained()->cascadeOnDelete();
            $table->foreignId('category_id')->constrained()->cascadeOnDelete();
            $table->smallInteger('year');
            $table->tinyInteger('month')->comment('1–12');
            $table->bigInteger('planned_cents')->unsigned();
            $table->timestamps();

            $table->unique(['household_id', 'category_id', 'year', 'month'], 'budgets_unique_period');
            $table->index(['household_id', 'year', 'month']);
        });

        Schema::create('goals', function (Blueprint $table) {
            $table->id();
            $table->foreignId('household_id')->constrained()->cascadeOnDelete();
            $table->string('name');
            $table->bigInteger('target_cents')->unsigned();
            $table->bigInteger('current_cents')->unsigned()->default(0);
            $table->date('due_date')->nullable();
            $table->enum('type', ['savings', 'debt']);
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        Schema::create('recurring_bills', function (Blueprint $table) {
            $table->id();
            $table->foreignId('household_id')->constrained()->cascadeOnDelete();
            $table->string('name');
            $table->bigInteger('amount_cents')->unsigned();
            $table->enum('frequency', ['daily', 'weekly', 'biweekly', 'monthly', 'quarterly', 'yearly']);
            $table->date('next_due');
            $table->foreignId('category_id')->nullable()->constrained()->nullOnDelete();
            $table->boolean('auto_pay')->default(false);
            $table->timestamps();

            $table->index(['household_id', 'next_due']);
        });

        Schema::create('category_rules', function (Blueprint $table) {
            $table->id();
            $table->foreignId('household_id')->constrained()->cascadeOnDelete();
            $table->string('match_pattern')->comment('Substring or regex matched against payee');
            $table->foreignId('category_id')->constrained()->cascadeOnDelete();
            $table->boolean('is_regex')->default(false);
            $table->timestamps();

            $table->index('household_id');
        });

        Schema::create('device_tokens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->text('token')->comment('FCM registration token');
            $table->enum('platform', ['ios', 'android']);
            $table->timestamps();

            $table->index('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('device_tokens');
        Schema::dropIfExists('category_rules');
        Schema::dropIfExists('recurring_bills');
        Schema::dropIfExists('goals');
        Schema::dropIfExists('budgets');
    }
};
