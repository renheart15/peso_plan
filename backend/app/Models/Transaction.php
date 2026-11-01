<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'household_id', 'account_id', 'category_id', 'created_by',
        'amount_cents', 'type', 'date', 'payee', 'notes', 'import_hash',
    ];

    protected $casts = [
        'amount_cents' => 'integer',
        'date' => 'date',
    ];

    public function household(): BelongsTo
    {
        return $this->belongsTo(Household::class);
    }

    public function account(): BelongsTo
    {
        return $this->belongsTo(Account::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class, 'transaction_tags');
    }

    public function splits(): HasMany
    {
        return $this->hasMany(TransactionSplit::class);
    }

    /** Compute SHA-256 import hash deterministically from key fields. */
    public static function computeImportHash(
        string $date,
        int $amountCents,
        string $payee,
        int $accountId
    ): string {
        return hash('sha256', implode('|', [$date, $amountCents, $payee, $accountId]));
    }
}
