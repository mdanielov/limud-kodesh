<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use DB;
use App\Http\Requests;
use App\Http\Controllers\Controller;
class SqlController extends Controller {

public function index(){

$initials = DB::table('tbl_user_initials')->select('initial')->distinct()->paginate(15);

$count = DB::select('select count(distinct initial)[count] from tbl_user_initials');

#var_dump($count);

return view('Initial_list',['initials'=>$initials,'count'=>$count]);
}
}