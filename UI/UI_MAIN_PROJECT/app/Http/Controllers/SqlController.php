<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use App\Http\Requests;
use App\Http\Controllers\Controller;

class SqlController extends Controller
{

    public function index()
    {

        $initials = DB::table('tbl_user_initials')->select('initial')->groupby('initial')->paginate(15);

        $count = DB::select('select count(distinct initial)[count] from tbl_user_initials');

        # var_dump($count);

        return view('Initial_list', ['initials' => $initials, 'count' => $count]);
    }

    public function initials_list()
    {

        $initials = DB::table('tbl_user_initials')->select('initial')->distinct()->get();

        return view('initial_list_dynamic', ['initials' => $initials]);
    }

    public function showInitial($initial)
    {

        $data['initial'] = $initial;

        $data['Total'] = DB::table('tbl_user_initials')->select('*')->whereRaw('initial = ?', $initial)->count();

        $initialPosition = DB::table('tbl_user_initials')->select(array('MASSECHET_NAME', 'DAF_NAME', 'AMUD_NAME', 'ROW_ID'))->whereRaw('initial = ?', $initial)->paginate(15);

        # var_dump($initialPosition);

        return view('Initial_resolve', ['data' => $data, 'initialPosition' => $initialPosition]);
    }

    public function ShowContext()
    {
        
        $initial = $_GET['initial'];
        $massechetName = $_GET['massechet'];
        $dafName = $_GET['daf'];
        $amudName = $_GET['amud'];
        $rowId  = $_GET['row'];

        $result['sentences'] = DB::select(DB::raw("SET NOCOUNT ON; exec P_GET_CONTEXT '$initial','$massechetName','$dafName','$amudName',".$rowId));        
        
        return $result['sentences'];
    }
}
