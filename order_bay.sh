#!/usr/bin/php
<?php
$openBay = 0;

// Переменные ставим свои -->
// we put our variables -->
$summBay = 2;//Сколько монет покупаем \ How many coins we buy
$summBayTxt = "2";//Cколько монет покупаем txt-формат !!!! \ How many coins do we buy, txt format
$pairOrder = "eth_btc";//Пара, которой торгуем \ pair we trade
$rateOrder = "0.0001";//Цена покупки \ purchase price
$moneta = "eth";//Монета, которую покупаем \ Coin, which we buy
// <-- Переменные ставим свои
// <-- we put our variables

// Получаем api_key, api_secret, nonce -->
// get api_key, api_secret, nonce -->
$file_api_key = fopen("api_key", "r");
$buffer_api_key = fgets($file_api_key, 4096);
fclose($file_api_key);

$file_api_secret = fopen("api_secret", "r");
$buffer_api_secret = fgets($file_api_secret, 4096);
fclose($file_api_secret);

$file_nonce = fopen("nonce", "r");
$buffer_nonce = fgets($file_nonce, 4096);
fclose($file_nonce);

$api_key    = $buffer_api_key;
$api_secret = $buffer_api_secret;
$nonce      = $buffer_nonce;
// <-- get api_key, api_secret, nonce
// <-- Получаем api_key, api_secret, nonce

// Создаём файл errors под ошибки -->
$fp = fopen("errors", "w+"); // Создаём файл errors
$create_errors_file = fwrite($fp, "\n"); // Запись в файл errors
if ($create_errors_file) echo "\nФайл errors успешно создан.\n";
else echo "\nОшибка создания файла errors!\n";
fclose($fp); //Закрытие файла errors
// <-- Создаём файл errors под ошибки

echo "\nOrder na ".$summBay." ".$moneta." sozdaetsa!\n";

$reqOrder['method'] = "Trade";
$reqOrder['pair'] = $pairOrder;
$reqOrder['type'] = "buy";
$reqOrder['rate'] = $rateOrder;
$reqOrder['amount'] = $summBayTxt;
$reqOrder['nonce'] = $nonce;
$post_dataOrder = http_build_query($reqOrder, '', '&');
$sign = hash_hmac("sha512", $post_dataOrder, $api_secret);
$headersOrder = array(
'Sign: '.$sign,
'Key: '.$api_key,
);
$ch = null;
$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; SMART_API PHP client; '.php_uname('s').'; PHP/'.phpversion().')');
curl_setopt($ch, CURLOPT_URL, 'https://yobit.net/tapi/');
curl_setopt($ch, CURLOPT_POSTFIELDS, $post_dataOrder);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headersOrder);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_ENCODING , 'gzip');
$resOrder = curl_exec($ch);

if($resOrder === false)
{
	echo "\nERROR! curl_exec method Trade!\n";
	$text_error = "\nERROR! curl_exec method Trade!\n";
	//пишем Error в файл errors
	$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
	$write_error = fwrite($fp, $text_error); // Запись в файл errors
	if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
	else echo "\nОшибка при записи в файл errors!\n";
	fclose($fp); //Закрытие файла errors
	curl_close($ch);
	goto m1;
}

curl_close($ch);
$result_decode = json_decode($resOrder, true);

if($result_decode['success'] == 0)
{
	echo "\nERROR! Method Trade! ".$result_decode['error']."\n";
	$text_error = "\nERROR! Method Trade! ".$result_decode['error']."\n";
	//пишем Error в файл errors
	$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
	$write_error = fwrite($fp, $text_error); // Запись в файл errors
	if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
	else echo "\nОшибка при записи в файл errors!\n";
	fclose($fp); //Закрытие файла errors
}
else if($result_decode['success'] == 1)
{
	$openBay = 1;
}
else
{
	echo "Unknown error method Trade!";
	$text_error = "\nERROR! Unknown error method Trade!\n";
	//пишем Error в файл errors
	$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
	$write_error = fwrite($fp, $text_error); // Запись в файл errors
	if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
	else echo "\nОшибка при записи в файл errors!\n";
	fclose($fp); //Закрытие файла errors
}

m1:
	
if($openBay == 1)
{
	echo "\nOrder sucess!\n";
	$nonce++;
	echo "\nNonce: ".$nonce."\n";
	//пишем Nonce в файл nonce
	$fp = fopen("nonce", "w+"); // Открываем файл nonce в режиме записи
	$write_nonce = fwrite($fp, $nonce); // Запись в файл nonce
	if ($write_nonce) echo "\nДанные в файл nonce успешно занесены.\n";
	else echo "\nОшибка при записи в файл nonce!\n";
	fclose($fp); //Закрытие файла nonce
}
else
{
	//echo "\nErrors!";
	$nonce++;
	echo "\nNonce: ".$nonce."\n";
	//пишем Nonce в файл nonce
	$fp = fopen("nonce", "w+"); // Открываем файл nonce в режиме записи
	$write_nonce = fwrite($fp, $nonce); // Запись в файл nonce
	if ($write_nonce) echo "\nДанные в файл nonce успешно занесены.\n";
	else echo "\nОшибка при записи в файл nonce!\n";
	fclose($fp); //Закрытие файла nonce
	echo "\nERROR! NO CREATE ORDER!\n";
}

$api_key    = NULL;
$api_secret = NULL;
$buffer_api_key = NULL;
$buffer_api_secret = NULL;
echo "\nEnd script\n";
?>