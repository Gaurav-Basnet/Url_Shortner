<?php

namespace App\Http\Controllers;

use App\Models\Desc;
use Illuminate\Http\Request;
use Str;

class UrlController extends Controller
{
    public function shortner(Request $request)
    {
        $validated = $request->validate([
            'original_url' => 'required|url|max:2048',

        ]);
        $random = Str::random(6);

        $url = Desc::create([
            'original_url' => $validated['original_url'],
            'short_code' => $random,
        ]);
        return response()->json([
            'short_url' => url($url->short_code),
            'short_code' => $url->short_code
        ]);
    }
    public function redirect($code)
    {
        $link = Desc::where('short_code', $code)->first();


        if ($link) {
            $long_url = $link->original_url;
            return redirect($long_url);
        }
        abort(404);

    }
}
