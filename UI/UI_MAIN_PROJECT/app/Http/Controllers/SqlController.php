<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use DB;
use App\Http\Requests;
use App\Http\Controllers\Controller;
class SqlController extends Controller {

public function index(){

$initials = DB::table('tbl_user_initials')->select('initial')->groupby('initial')-> paginate(15);

$count = DB::select('select count(distinct initial)[count] from tbl_user_initials');

#var_dump($count);

return view('Initial_list',['initials'=>$initials,'count'=>$count]);
}

public function FilterTable(Request $request)
{

$initials = DB::table('tbl_user_initials')->select('initial')->groupby('initial')-> paginate(15);
 
$inputSearch = (!empty($_GET["inputSearch"])) ? ($_GET["start_date"]) : ('');

$initials->whereRaw("initial like '" . $inputSearch . "'");

$result = $initials->select('*');

$currentPage = $request->page_num;
Paginator::currentPageResolver(function() use ($currentPage) {
    return $currentPage;
});

return datatables()->of($result)
    ->make(true);
    }

}