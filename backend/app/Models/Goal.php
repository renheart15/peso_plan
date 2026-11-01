<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Goal extends Model
{
    protected $fillable = [
        'household_id', 'name', 'target_cents', 'current_cents', 'due_date', 'type', 'notes',
    ];

    protected $casts = [
        'target_cents' => 'integer',
        'current_cents' => 'integer',
        'due_date' => 'date',
    ];

    public function household(): BelongsTo
    {
        return $this->belongsTo(Household::class);
    }

    /** Percentage progress 0–100. */
    public function progressPercent(): float
    {
        if ($this->target_cents <= 0) {
            return 0;
        }

        return min(100, round($this->current_cents / $this->target_cents * 100, 2));
    }
}
