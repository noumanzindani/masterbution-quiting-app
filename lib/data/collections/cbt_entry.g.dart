// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cbt_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCbtEntryCollection on Isar {
  IsarCollection<CbtEntry> get cbtEntrys => this.collection();
}

const CbtEntrySchema = CollectionSchema(
  name: r'CbtEntry',
  id: -8916139634865615708,
  properties: {
    r'dateEpochDay': PropertySchema(
      id: 0,
      name: r'dateEpochDay',
      type: IsarType.long,
    ),
    r'exercise': PropertySchema(
      id: 1,
      name: r'exercise',
      type: IsarType.byte,
      enumMap: _CbtEntryexerciseEnumValueMap,
    ),
    r'responsesJson': PropertySchema(
      id: 2,
      name: r'responsesJson',
      type: IsarType.string,
    ),
    r'timestampUtc': PropertySchema(
      id: 3,
      name: r'timestampUtc',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(id: 4, name: r'title', type: IsarType.string),
    r'worksheetId': PropertySchema(
      id: 5,
      name: r'worksheetId',
      type: IsarType.string,
    ),
  },

  estimateSize: _cbtEntryEstimateSize,
  serialize: _cbtEntrySerialize,
  deserialize: _cbtEntryDeserialize,
  deserializeProp: _cbtEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'timestampUtc': IndexSchema(
      id: -10283478508442510,
      name: r'timestampUtc',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestampUtc',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'dateEpochDay': IndexSchema(
      id: -2614349907588171094,
      name: r'dateEpochDay',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateEpochDay',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _cbtEntryGetId,
  getLinks: _cbtEntryGetLinks,
  attach: _cbtEntryAttach,
  version: '3.3.2',
);

int _cbtEntryEstimateSize(
  CbtEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.responsesJson.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.worksheetId.length * 3;
  return bytesCount;
}

void _cbtEntrySerialize(
  CbtEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateEpochDay);
  writer.writeByte(offsets[1], object.exercise.index);
  writer.writeString(offsets[2], object.responsesJson);
  writer.writeDateTime(offsets[3], object.timestampUtc);
  writer.writeString(offsets[4], object.title);
  writer.writeString(offsets[5], object.worksheetId);
}

CbtEntry _cbtEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CbtEntry();
  object.dateEpochDay = reader.readLong(offsets[0]);
  object.exercise =
      _CbtEntryexerciseValueEnumMap[reader.readByteOrNull(offsets[1])] ??
      CbtExercise.automaticThought;
  object.id = id;
  object.responsesJson = reader.readString(offsets[2]);
  object.timestampUtc = reader.readDateTime(offsets[3]);
  object.title = reader.readString(offsets[4]);
  object.worksheetId = reader.readString(offsets[5]);
  return object;
}

P _cbtEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (_CbtEntryexerciseValueEnumMap[reader.readByteOrNull(offset)] ??
              CbtExercise.automaticThought)
          as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CbtEntryexerciseEnumValueMap = {
  'automaticThought': 0,
  'distortion': 1,
  'thoughtReplacement': 2,
  'triggerAnalysis': 3,
  'emotionLabel': 4,
  'behavioralExperiment': 5,
  'exposure': 6,
  'urgeSurf': 7,
  'delayedGratification': 8,
  'acceptance': 9,
};
const _CbtEntryexerciseValueEnumMap = {
  0: CbtExercise.automaticThought,
  1: CbtExercise.distortion,
  2: CbtExercise.thoughtReplacement,
  3: CbtExercise.triggerAnalysis,
  4: CbtExercise.emotionLabel,
  5: CbtExercise.behavioralExperiment,
  6: CbtExercise.exposure,
  7: CbtExercise.urgeSurf,
  8: CbtExercise.delayedGratification,
  9: CbtExercise.acceptance,
};

Id _cbtEntryGetId(CbtEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cbtEntryGetLinks(CbtEntry object) {
  return [];
}

void _cbtEntryAttach(IsarCollection<dynamic> col, Id id, CbtEntry object) {
  object.id = id;
}

extension CbtEntryQueryWhereSort on QueryBuilder<CbtEntry, CbtEntry, QWhere> {
  QueryBuilder<CbtEntry, CbtEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhere> anyTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestampUtc'),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhere> anyDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateEpochDay'),
      );
    });
  }
}

extension CbtEntryQueryWhere on QueryBuilder<CbtEntry, CbtEntry, QWhereClause> {
  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> timestampUtcEqualTo(
    DateTime timestampUtc,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'timestampUtc',
          value: [timestampUtc],
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> timestampUtcNotEqualTo(
    DateTime timestampUtc,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [],
                upper: [timestampUtc],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [timestampUtc],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [timestampUtc],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [],
                upper: [timestampUtc],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> timestampUtcGreaterThan(
    DateTime timestampUtc, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestampUtc',
          lower: [timestampUtc],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> timestampUtcLessThan(
    DateTime timestampUtc, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestampUtc',
          lower: [],
          upper: [timestampUtc],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> timestampUtcBetween(
    DateTime lowerTimestampUtc,
    DateTime upperTimestampUtc, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestampUtc',
          lower: [lowerTimestampUtc],
          includeLower: includeLower,
          upper: [upperTimestampUtc],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> dateEpochDayEqualTo(
    int dateEpochDay,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'dateEpochDay',
          value: [dateEpochDay],
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> dateEpochDayNotEqualTo(
    int dateEpochDay,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [],
                upper: [dateEpochDay],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [dateEpochDay],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [dateEpochDay],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [],
                upper: [dateEpochDay],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> dateEpochDayGreaterThan(
    int dateEpochDay, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateEpochDay',
          lower: [dateEpochDay],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> dateEpochDayLessThan(
    int dateEpochDay, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateEpochDay',
          lower: [],
          upper: [dateEpochDay],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterWhereClause> dateEpochDayBetween(
    int lowerDateEpochDay,
    int upperDateEpochDay, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateEpochDay',
          lower: [lowerDateEpochDay],
          includeLower: includeLower,
          upper: [upperDateEpochDay],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CbtEntryQueryFilter
    on QueryBuilder<CbtEntry, CbtEntry, QFilterCondition> {
  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> dateEpochDayEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateEpochDay', value: value),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  dateEpochDayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateEpochDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> dateEpochDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateEpochDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> dateEpochDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateEpochDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> exerciseEqualTo(
    CbtExercise value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'exercise', value: value),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> exerciseGreaterThan(
    CbtExercise value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'exercise',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> exerciseLessThan(
    CbtExercise value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'exercise',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> exerciseBetween(
    CbtExercise lower,
    CbtExercise upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'exercise',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> responsesJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'responsesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  responsesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'responsesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> responsesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'responsesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> responsesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'responsesJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  responsesJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'responsesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> responsesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'responsesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> responsesJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'responsesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> responsesJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'responsesJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  responsesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'responsesJson', value: ''),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  responsesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'responsesJson', value: ''),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> timestampUtcEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestampUtc', value: value),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  timestampUtcGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestampUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> timestampUtcLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestampUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> timestampUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestampUtc',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'worksheetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  worksheetIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'worksheetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'worksheetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'worksheetId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'worksheetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'worksheetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'worksheetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'worksheetId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition> worksheetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'worksheetId', value: ''),
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterFilterCondition>
  worksheetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'worksheetId', value: ''),
      );
    });
  }
}

extension CbtEntryQueryObject
    on QueryBuilder<CbtEntry, CbtEntry, QFilterCondition> {}

extension CbtEntryQueryLinks
    on QueryBuilder<CbtEntry, CbtEntry, QFilterCondition> {}

extension CbtEntryQuerySortBy on QueryBuilder<CbtEntry, CbtEntry, QSortBy> {
  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByResponsesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responsesJson', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByResponsesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responsesJson', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByWorksheetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worksheetId', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> sortByWorksheetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worksheetId', Sort.desc);
    });
  }
}

extension CbtEntryQuerySortThenBy
    on QueryBuilder<CbtEntry, CbtEntry, QSortThenBy> {
  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByResponsesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responsesJson', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByResponsesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responsesJson', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByWorksheetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worksheetId', Sort.asc);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QAfterSortBy> thenByWorksheetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worksheetId', Sort.desc);
    });
  }
}

extension CbtEntryQueryWhereDistinct
    on QueryBuilder<CbtEntry, CbtEntry, QDistinct> {
  QueryBuilder<CbtEntry, CbtEntry, QDistinct> distinctByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateEpochDay');
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QDistinct> distinctByExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exercise');
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QDistinct> distinctByResponsesJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'responsesJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QDistinct> distinctByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestampUtc');
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CbtEntry, CbtEntry, QDistinct> distinctByWorksheetId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'worksheetId', caseSensitive: caseSensitive);
    });
  }
}

extension CbtEntryQueryProperty
    on QueryBuilder<CbtEntry, CbtEntry, QQueryProperty> {
  QueryBuilder<CbtEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CbtEntry, int, QQueryOperations> dateEpochDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateEpochDay');
    });
  }

  QueryBuilder<CbtEntry, CbtExercise, QQueryOperations> exerciseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exercise');
    });
  }

  QueryBuilder<CbtEntry, String, QQueryOperations> responsesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'responsesJson');
    });
  }

  QueryBuilder<CbtEntry, DateTime, QQueryOperations> timestampUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestampUtc');
    });
  }

  QueryBuilder<CbtEntry, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<CbtEntry, String, QQueryOperations> worksheetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'worksheetId');
    });
  }
}
