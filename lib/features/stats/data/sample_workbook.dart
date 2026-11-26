import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

Uint8List createSampleWorkbook() {
  final workbook = Archive();
  _addFile(
    workbook,
    '[Content_Types].xml',
    '''<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
 <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
 <Default Extension="xml" ContentType="application/xml"/>
 <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
 <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
</Types>''',
  );
  _addFile(workbook, '_rels/.rels', '''<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
 <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>''');
  _addFile(
    workbook,
    'xl/workbook.xml',
    '''<?xml version="1.0" encoding="UTF-8"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
 <sheets><sheet name="Thong ke de tai" sheetId="1" r:id="rId1"/></sheets>
</workbook>''',
  );
  _addFile(
    workbook,
    'xl/_rels/workbook.xml.rels',
    '''<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
 <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
</Relationships>''',
  );
  _addFile(
    workbook,
    'xl/worksheets/sheet1.xml',
    '''<?xml version="1.0" encoding="UTF-8"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
 <sheetData>
  <row r="1"><c r="A1" t="inlineStr"><is><t>Hủy</t></is></c><c r="B1" t="inlineStr"><is><t>Duyệt</t></is></c><c r="C1" t="inlineStr"><is><t>Trễ</t></is></c></row>
  <row r="2"><c r="A2"><v>3</v></c><c r="B2"><v>8</v></c><c r="C2"><v>2</v></c></row>
 </sheetData>
</worksheet>''',
  );
  return Uint8List.fromList(ZipEncoder().encode(workbook));
}

void _addFile(Archive archive, String name, String content) {
  final bytes = Uint8List.fromList(utf8.encode(content));
  archive.addFile(ArchiveFile(name, bytes.length, bytes));
}
