<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use App\Http\Requests;
use App\Http\Controllers\Controller;

class InitialController extends Controller
{

    public function index(Request $request)
    {

        $initialAll = DB::table('tbl_user_initials')->select('initial')->groupby('initial')->get();

        $initials = DB::table('tbl_user_initials')->select('initial')->groupby('initial')->paginate(15);

        $count = DB::select('select count(distinct initial)[count] from tbl_user_initials');

        # var_dump($count);

        return view('Initial_list', ['initialAll' => $initialAll, 'initials' => $initials, 'count' => $count]);
    }

    public function showInitial($initial)
    {

        $data['initial'] = $initial;

        $data['Total'] = DB::table('tbl_user_initials')->select('*')->whereRaw('initial = ?', $initial)->count();

        $unresolved = DB::select(DB::raw("SET NOCOUNT ON; exec P_GET_INITIALS '$initial'"));

        $data['unresolved'] = count($unresolved);

        $initialPosition = DB::table('tbl_user_initials')->select(array('MASSECHET_NAME', 'DAF_NAME', 'AMUD_NAME', 'ROW_ID'))->whereRaw('initial = ?', $initial)->paginate(15);

        # $initialPosition = collect(DB::select(DB::raw("SET NOCOUNT ON; exec P_GET_INITIALS '$initial'")))->paginate();

        $page = request('page', 1);

        $paginate = 10;

        $dataResult = DB::select(DB::raw("SET NOCOUNT ON; exec P_GET_INITIALS '$initial'"));

        $offSet = ($page * $paginate) - $paginate;

        $itemsForCurrentPage = array_slice($dataResult, $offSet, $paginate, true);

        $initialPosition = new \Illuminate\Pagination\LengthAwarePaginator($itemsForCurrentPage, count($dataResult), $paginate);

        $initialPosition->setPath(url()->current());

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

        $result['sentences'] = DB::select(DB::raw("SET NOCOUNT ON; exec P_GET_CONTEXT '$initial','$massechetName','$dafName','$amudName'," . $rowId));

        return $result['sentences'];
    }


    public function SubmitTableInsert()
    {
        $initial = $_GET['initial'];
        $massechetName = $_GET['massechet'];
        $dafName = $_GET['daf'];
        $amudName = $_GET['amud'];
        $rowId  = $_GET['row_num'];
        $definition = $_GET['definition'];

        $insert['row'] = DB::table('TBL_SUBMITED_DEF')->insert(['WORD_INITIAL' => $initial, 'MASSECHET_NAME' =>  $massechetName, 'DAF_NAME' => $dafName, 'AMUD_NAME' =>  $amudName, 'ROW_ID' => $rowId, 'SUBMITED_DEF' =>  $definition]);
    }
}
