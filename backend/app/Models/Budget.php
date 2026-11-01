<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Budget extends Model
{
    protected $fillable = ['household_id', 'category_id', 'year', 'month', 'planned_cents'];

    protected $casts = ['planned_cents' => 'integer', 'year' => 'integer', 'month' => 'integer'];

    public function household(): BelongsTo
    {
        return $this->belongsTo(Household::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }
}
