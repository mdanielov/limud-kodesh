<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use URL;


class TanakhController extends Controller
{
    function index()
    {
        $data = [];

        $data['torah'] = DB::table('TBL_TANAKH_SEFER')->select('SEFER_HEBREW_NAME', 'SEFER_ENGLISH_NAME')->where('CATEGORY_ID', '=', '1')->get();
        $data['neviim'] = DB::table('TBL_TANAKH_SEFER')->select('SEFER_HEBREW_NAME', 'SEFER_ENGLISH_NAME')->where('CATEGORY_ID', '=', '2')->orWhere('CATEGORY_ID', '=', '3')->get();

        return view('Tanakh', ['data' => $data]);
    }

    function GetSection($section)
    {
        return redirect('tanakh#'.$section);
    }
}
