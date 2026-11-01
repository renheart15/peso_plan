<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Household extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'owner_id'];

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function members(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'household_members')
            ->withPivot('role')
            ->withTimestamps();
    }

    public function accounts(): HasMany
    {
        return $this->hasMany(Account::class);
    }

    public function categories(): HasMany
    {
        return $this->hasMany(Category::class);
    }

    public function transactions(): HasMany
    {
        return $this->hasMany(Transaction::class);
    }

    public function budgets(): HasMany
    {
        return $this->hasMany(Budget::class);
    }

    public function goals(): HasMany
    {
        return $this->hasMany(Goal::class);
    }

    public function recurringBills(): HasMany
    {
        return $this->hasMany(RecurringBill::class);
    }

    public function categoryRules(): HasMany
    {
        return $this->hasMany(CategoryRule::class);
    }

    /** Check if a user is a member with at least the given role. */
    public function userHasRole(User $user, string ...$roles): bool
    {
        return $this->members()
            ->where('users.id', $user->id)
            ->wherePivotIn('role', $roles)
            ->exists();
    }

    public function isMember(User $user): bool
    {
        return $this->userHasRole($user, 'owner', 'partner', 'viewer');
    }

    public function canEdit(User $user): bool
    {
        return $this->userHasRole($user, 'owner', 'partner');
    }

    public function isOwner(User $user): bool
    {
        return $this->userHasRole($user, 'owner');
    }
}
