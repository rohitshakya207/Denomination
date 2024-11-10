class CalCulateDataModel {
  final int? id;
  final String date;
  final String remark;
  final String recordtime;
  final String categery;
  final String wordtotal;
  final int finalalltotal;
  final int amount2000;
  final int multi2000;
  final int amount500;
  final int multi500;
  final int amount200;
  final int multi200;
  final int amount100;
  final int multi100;
  final int amount50;
  final int multi50;
  final int amount20;
  final int multi20;
  final int amount10;
  final int multi10;
  final int amount5;
  final int multi5;
  final int amount2;
  final int multi2;
  final int amount1;
  final int multi1;

  CalCulateDataModel({
    this.id,
    required this.date,
    required this.remark,
    required this.recordtime,
    required this.categery,
    required this.wordtotal,
    required this.finalalltotal,
    required this.amount2000,
    required this.multi2000,
    required this.amount500,
    required this.multi500,
    required this.amount200,
    required this.multi200,
    required this.amount100,
    required this.multi100,
    required this.amount50,
    required this.multi50,
    required this.amount20,
    required this.multi20,
    required this.amount10,
    required this.multi10,
    required this.amount5,
    required this.multi5,
    required this.amount2,
    required this.multi2,
    required this.amount1,
    required this.multi1,
  });

  // Dynamically calculate the total value of the transaction based on amounts and multipliers
  int get finalTotal {
    return (amount2000 * multi2000) +
        (amount500 * multi500) +
        (amount200 * multi200) +
        (amount100 * multi100) +
        (amount50 * multi50) +
        (amount20 * multi20) +
        (amount10 * multi10) +
        (amount5 * multi5) +
        (amount2 * multi2) +
        (amount1 * multi1);
  }

  // Convert a Transaction into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'remark': remark,
      'recordtime': recordtime,
      'categery': categery,
      'wordtotal': wordtotal,
      'finalalltotal': finalalltotal,
      'amount2000': amount2000,
      'multi2000': multi2000,
      'amount500': amount500,
      'multi500': multi500,
      'amount200': amount200,
      'multi200': multi200,
      'amount100': amount100,
      'multi100': multi100,
      'amount50': amount50,
      'multi50': multi50,
      'amount20': amount20,
      'multi20': multi20,
      'amount10': amount10,
      'multi10': multi10,
      'amount5': amount5,
      'multi5': multi5,
      'amount2': amount2,
      'multi2': multi2,
      'amount1': amount1,
      'multi1': multi1,
    };
  }

  // Convert a Map into a Transaction object
  static CalCulateDataModel fromMap(Map<String, dynamic> map) {
    return CalCulateDataModel(
      id: map['id'],
      date: map['date'],
      remark: map['remark'],
      recordtime: map['recordtime'],
      categery: map['categery'],
      wordtotal: map['wordtotal'],
      finalalltotal: map['finalalltotal'],
      amount2000: map['amount2000'],
      multi2000: map['multi2000'],
      amount500: map['amount500'],
      multi500: map['multi500'],
      amount200: map['amount200'],
      multi200: map['multi200'],
      amount100: map['amount100'],
      multi100: map['multi100'],
      amount50: map['amount50'],
      multi50: map['multi50'],
      amount20: map['amount20'],
      multi20: map['multi20'],
      amount10: map['amount10'],
      multi10: map['multi10'],
      amount5: map['amount5'],
      multi5: map['multi5'],
      amount2: map['amount2'],
      multi2: map['multi2'],
      amount1: map['amount1'],
      multi1: map['multi1'],
    );
  }
}
