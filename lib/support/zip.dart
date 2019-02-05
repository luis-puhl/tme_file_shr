import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

manualZip() {
  var encoder = new ZipFileEncoder();
  // Manually create a zip of a directory and individual files.
  encoder.create('out2.zip');
  encoder.addDirectory(new Directory('out'));
  encoder.addFile(new File('test.zip'));
  encoder.close();
}
