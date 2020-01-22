<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use DB;
use App\Http\Requests;
use App\Http\Controllers\Controller;
class SqlController extends Controller {

public function index(){

$initials = DB::select('select distinct initial from tbl_user_initials');
$count = DB::select('select count(distinct initial)[count] from tbl_user_initials');
#var_dump($count);
return view('hello',['initials'=>$initials,'count'=>$count]);
}
}