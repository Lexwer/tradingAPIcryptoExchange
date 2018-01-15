<?php
$get_generate = getopt("p::");

// generate files: nonce, api_key, api_secret -->

if($get_generate["p"] == "gen"){
	
	// insert\edit variables -->
	$my_nonce = 'my_nonce';// nonce YoBit, default 1
	$my_api_key = 'my_api_key';// api_key YoBit 
	$my_api_secret = 'my_api_secret';// api_secret YoBit
	// <-- insert\edit variables
	
	$fp = fopen("nonce", "w+"); // Открываем файл в режиме записи
	$mytext = $my_nonce; // nonce
	$test = fwrite($fp, $mytext); // Запись в файл
	if ($test) echo "\nДанные в файл успешно занесены.\n";
	else echo "\nОшибка при записи в файл.\n";
	fclose($fp); //Закрытие файла

	$fp = fopen("api_key", "w+"); // Открываем файл в режиме записи
	$mytext = $my_api_key; // api_key
	$test = fwrite($fp, $mytext); // Запись в файл
	if ($test) echo "\nДанные в файл успешно занесены.\n";
	else echo "\nОшибка при записи в файл.\n";
	fclose($fp); //Закрытие файла

	$fp = fopen("api_secret", "w+"); // Открываем файл в режиме записи
	$mytext = $my_api_secret; // api_secret
	$test = fwrite($fp, $mytext); // Запись в файл
	if ($test) echo "\nДанные в файл успешно занесены.\n";
	else echo "\nОшибка при записи в файл.\n";
	fclose($fp); //Закрытие файла
}
// <-- generate files: nonce, api_key, api_secret

// get api key, secret -->

$file_api_key = fopen("api_key", "r");
$buffer_api_key = fgets($file_api_key, 4096);
fclose($file_api_key);

$file_api_secret = fopen("api_secret", "r");
$buffer_api_secret = fgets($file_api_secret, 4096);
fclose($file_api_secret);

$api_key    = $buffer_api_key;
$api_secret = $buffer_api_secret;

// <-- get api key, secret

// get nonce -->

$file_nonce = fopen("nonce", "r");
$buffer_nonce = fgets($file_nonce, 4096);
fclose($file_nonce);

$nonce = $buffer_nonce;

// <-- get nonce

echo "\n".$nonce." - nonce\n";
echo $api_secret." - api_secret\n";
echo $api_key." - api_key\n\n";

?>