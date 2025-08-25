<?php

use App\Http\Controllers\UrlController;
use Illuminate\Support\Facades\Route;

Route::get('/{code}',[UrlController::class,'redirect'])->name('url.get');

Route::post('/short', [UrlController::class, 'shortner'])->name('url.short');
    

Route::get('/', function () {
    return view('welcome'); // or any Blade file where your Vue form is mounted
})->name('home');
