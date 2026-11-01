<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class RecurringBill extends Model
{
    protected $fillable = [
        'household_id', 'name', 'amount_cents', 'frequency', 'next_due', 'category_id', 'auto_pay',
    ];

    protected $casts = [
        'amount_cents' => 'integer',
        'next_due' => 'date',
        'auto_pay' => 'boolean',
    ];

    public function household(): BelongsTo
    {
        return $this->belongsTo(Household::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }
}
