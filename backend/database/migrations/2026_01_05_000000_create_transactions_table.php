<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('household_id')->constrained()->cascadeOnDelete();
            $table->foreignId('account_id')->constrained()->cascadeOnDelete();
            $table->foreignId('category_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('created_by')->constrained('users');
            $table->bigInteger('amount_cents')->unsigned()->comment('Always positive; type field determines sign');
            $table->enum('type', ['income', 'expense', 'transfer']);
            $table->date('date');
            $table->string('payee')->nullable();
            $table->text('notes')->nullable();
            $table->char('import_hash', 64)->nullable()->comment('SHA-256 for CSV deduplication');
            $table->timestamps();

            $table->index(['household_id', 'date']);
            $table->index(['household_id', 'account_id']);
            $table->index(['household_id', 'category_id']);
            $table->unique(['household_id', 'import_hash'], 'transactions_import_hash_unique');
        });

        Schema::create('transaction_tags', function (Blueprint $table) {
            $table->foreignId('transaction_id')->constrained()->cascadeOnDelete();
            $table->foreignId('tag_id')->constrained()->cascadeOnDelete();
            $table->primary(['transaction_id', 'tag_id']);
        });

        Schema::create('transaction_splits', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaction_id')->constrained()->cascadeOnDelete();
            $table->foreignId('category_id')->constrained();
            $table->bigInteger('amount_cents')->unsigned();
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_splits');
        Schema::dropIfExists('transaction_tags');
        Schema::dropIfExists('transactions');
    }
};
