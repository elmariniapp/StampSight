import 'package:flutter_test/flutter_test.dart';
import 'package:stampsight/core/utils/proof_reference_label.dart';

void main() {
  test('proofReferenceLabelFromProofId matches PDF convention', () {
    const id = 'abcdef12-3456-7890-abcd-ef1234567890';
    expect(proofReferenceLabelFromProofId(id), 'SS-ABCDEF12');
  });
}
