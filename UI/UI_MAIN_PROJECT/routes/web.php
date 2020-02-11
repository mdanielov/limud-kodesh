<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/','HomeController@index');

Route::get('/home','HomeController@index');

Route::get('/initial','InitialController@index');

Route::get('/initial/{value}', 'InitialController@showInitial')->name('initial');

Route::get('/context/{MASSECHET_NAME}/{DAF_NAME}/{AMUD_NAME}/{ROW_ID}','InitialController@getContext')->name('Massechet');

Route::get('/ShowContext/{initial}/{massechet}/{daf}/{amud}/{row}','InitialController@ShowContext')->name('ShowContext');

Route::get('/initial/{initial}/{massechet}/{daf}/{amud}/{row_num}/{definition}','InitialController@SubmitTableInsert')->name('SubmitTableInsert');
