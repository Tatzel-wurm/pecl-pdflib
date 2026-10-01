--TEST--
PDFlib 11 does not expose APIs removed from the C library
--SKIPIF--
<?php
if (!extension_loaded('PDFlib')) {
    die('skip PDFlib extension not loaded');
}
$pdf = new PDFlib();
if ($pdf->get_option('major', '') < 11) {
    die('skip requires PDFlib 11 or newer');
}
?>
--FILE--
<?php
$pdf = new PDFlib();
var_dump(method_exists($pdf, 'begin_page'));
var_dump(method_exists($pdf, 'begin_page_ext'));
var_dump(function_exists('pdf_open_file'));
var_dump(function_exists('pdf_load_image'));
?>
--EXPECT--
bool(false)
bool(true)
bool(false)
bool(true)
