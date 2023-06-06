<?php

namespace totum\config;

use totum\common\configs\WithPhpMailerSmtpTrait;
use totum\common\configs\ConfParent;
use totum\common\configs\MultiTrait;

class Conf extends ConfParent
{

 use MultiTrait;
 use WithPhpMailerSmtpTrait;

 protected $SmtpData = [
  'host' => 'ssl://smtp.yandex.ru',
  'port' => '465',
  'login' => 'SERVICE_MAIL',
  'pass' => 'PASSWORD',
 ];

 const db = array (
  'dsn' => 'pgsql:host=db;port=5432;dbname=totum',
  'host' => 'db',
  'username' => 'totum',
  'dbname' => 'totum',
  'password' => 'STRONG_DB_PASSWORD',
  'charset' => 'UTF8',
  'pg_dump' => 'pg_dump',
  'psql' => 'psql',
 );

 public static $timeLimit = 120;

 const adminEmail='ADMIN_MAIL';
 const ANONYM_ALIAS='An';
 const LANG="ru";

 protected $execSSHOn = 'inner';

 static function getSchemas()
 {
  return ['PROXY_DOMAIN'=>'production'];
 }

 public function setSessionCookieParams()
 {
  session_set_cookie_params([
   'path' => '/',
   'httponly' => true,
   'samesite' => 'Lax'
  ]);
 }
}