<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CategoryRule extends Model
{
    use HasFactory;

    protected $fillable = [
        'household_id',
        'category_id',
        'match_pattern', // substring or regex matched against payee
        'is_regex',
    ];

    protected $casts = [
        'is_regex' => 'boolean',
    ];

    // ── Relationships ─────────────────────────────────────────────────────────

    public function household(): BelongsTo
    {
        return $this->belongsTo(Household::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /**
     * Test whether this rule matches the given payee string.
     */
    public function matches(string $payee): bool
    {
        if ($this->is_regex) {
            return (bool) preg_match('/'.$this->match_pattern.'/i', $payee);
        }

        return str_contains(strtolower($payee), strtolower($this->match_pattern));
    }
}
