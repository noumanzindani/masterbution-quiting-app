// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_result.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssessmentResultCollection on Isar {
  IsarCollection<AssessmentResult> get assessmentResults => this.collection();
}

const AssessmentResultSchema = CollectionSchema(
  name: r'AssessmentResult',
  id: 6964178635660755874,
  properties: {
    r'adhdScore': PropertySchema(
      id: 0,
      name: r'adhdScore',
      type: IsarType.long,
    ),
    r'anxietyScore': PropertySchema(
      id: 1,
      name: r'anxietyScore',
      type: IsarType.long,
    ),
    r'depressionScore': PropertySchema(
      id: 2,
      name: r'depressionScore',
      type: IsarType.long,
    ),
    r'frequencyScore': PropertySchema(
      id: 3,
      name: r'frequencyScore',
      type: IsarType.long,
    ),
    r'planId': PropertySchema(id: 4, name: r'planId', type: IsarType.string),
    r'rawAnswersJson': PropertySchema(
      id: 5,
      name: r'rawAnswersJson',
      type: IsarType.string,
    ),
    r'recoveryDifficultyScore': PropertySchema(
      id: 6,
      name: r'recoveryDifficultyScore',
      type: IsarType.long,
    ),
    r'sleepScore': PropertySchema(
      id: 7,
      name: r'sleepScore',
      type: IsarType.long,
    ),
    r'stressScore': PropertySchema(
      id: 8,
      name: r'stressScore',
      type: IsarType.long,
    ),
    r'suggestedGoal': PropertySchema(
      id: 9,
      name: r'suggestedGoal',
      type: IsarType.byte,
      enumMap: _AssessmentResultsuggestedGoalEnumValueMap,
    ),
    r'timestampUtc': PropertySchema(
      id: 10,
      name: r'timestampUtc',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _assessmentResultEstimateSize,
  serialize: _assessmentResultSerialize,
  deserialize: _assessmentResultDeserialize,
  deserializeProp: _assessmentResultDeserializeProp,
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
  },
  links: {},
  embeddedSchemas: {},

  getId: _assessmentResultGetId,
  getLinks: _assessmentResultGetLinks,
  attach: _assessmentResultAttach,
  version: '3.3.2',
);

int _assessmentResultEstimateSize(
  AssessmentResult object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.planId.length * 3;
  bytesCount += 3 + object.rawAnswersJson.length * 3;
  return bytesCount;
}

void _assessmentResultSerialize(
  AssessmentResult object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.adhdScore);
  writer.writeLong(offsets[1], object.anxietyScore);
  writer.writeLong(offsets[2], object.depressionScore);
  writer.writeLong(offsets[3], object.frequencyScore);
  writer.writeString(offsets[4], object.planId);
  writer.writeString(offsets[5], object.rawAnswersJson);
  writer.writeLong(offsets[6], object.recoveryDifficultyScore);
  writer.writeLong(offsets[7], object.sleepScore);
  writer.writeLong(offsets[8], object.stressScore);
  writer.writeByte(offsets[9], object.suggestedGoal.index);
  writer.writeDateTime(offsets[10], object.timestampUtc);
}

AssessmentResult _assessmentResultDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssessmentResult();
  object.adhdScore = reader.readLong(offsets[0]);
  object.anxietyScore = reader.readLong(offsets[1]);
  object.depressionScore = reader.readLong(offsets[2]);
  object.frequencyScore = reader.readLong(offsets[3]);
  object.id = id;
  object.planId = reader.readString(offsets[4]);
  object.rawAnswersJson = reader.readString(offsets[5]);
  object.recoveryDifficultyScore = reader.readLong(offsets[6]);
  object.sleepScore = reader.readLong(offsets[7]);
  object.stressScore = reader.readLong(offsets[8]);
  object.suggestedGoal =
      _AssessmentResultsuggestedGoalValueEnumMap[reader.readByteOrNull(
        offsets[9],
      )] ??
      GoalType.quitPorn;
  object.timestampUtc = reader.readDateTime(offsets[10]);
  return object;
}

P _assessmentResultDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (_AssessmentResultsuggestedGoalValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              GoalType.quitPorn)
          as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AssessmentResultsuggestedGoalEnumValueMap = {
  'quitPorn': 0,
  'quitMasturbation': 1,
  'reduceFrequency': 2,
  'healthyHabits': 3,
};
const _AssessmentResultsuggestedGoalValueEnumMap = {
  0: GoalType.quitPorn,
  1: GoalType.quitMasturbation,
  2: GoalType.reduceFrequency,
  3: GoalType.healthyHabits,
};

Id _assessmentResultGetId(AssessmentResult object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _assessmentResultGetLinks(AssessmentResult object) {
  return [];
}

void _assessmentResultAttach(
  IsarCollection<dynamic> col,
  Id id,
  AssessmentResult object,
) {
  object.id = id;
}

extension AssessmentResultQueryWhereSort
    on QueryBuilder<AssessmentResult, AssessmentResult, QWhere> {
  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhere>
  anyTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestampUtc'),
      );
    });
  }
}

extension AssessmentResultQueryWhere
    on QueryBuilder<AssessmentResult, AssessmentResult, QWhereClause> {
  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause> idBetween(
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  timestampUtcEqualTo(DateTime timestampUtc) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'timestampUtc',
          value: [timestampUtc],
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  timestampUtcNotEqualTo(DateTime timestampUtc) {
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  timestampUtcGreaterThan(DateTime timestampUtc, {bool include = false}) {
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  timestampUtcLessThan(DateTime timestampUtc, {bool include = false}) {
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterWhereClause>
  timestampUtcBetween(
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
}

extension AssessmentResultQueryFilter
    on QueryBuilder<AssessmentResult, AssessmentResult, QFilterCondition> {
  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  adhdScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'adhdScore', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  adhdScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'adhdScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  adhdScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'adhdScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  adhdScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'adhdScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  anxietyScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'anxietyScore', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  anxietyScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'anxietyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  anxietyScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'anxietyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  anxietyScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'anxietyScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  depressionScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'depressionScore', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  depressionScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'depressionScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  depressionScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'depressionScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  depressionScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'depressionScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  frequencyScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'frequencyScore', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  frequencyScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'frequencyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  frequencyScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'frequencyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  frequencyScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'frequencyScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'planId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'planId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'planId', value: ''),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'planId', value: ''),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rawAnswersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rawAnswersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rawAnswersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rawAnswersJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rawAnswersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rawAnswersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rawAnswersJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rawAnswersJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rawAnswersJson', value: ''),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  rawAnswersJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rawAnswersJson', value: ''),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  recoveryDifficultyScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recoveryDifficultyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  recoveryDifficultyScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recoveryDifficultyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  recoveryDifficultyScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recoveryDifficultyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  recoveryDifficultyScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recoveryDifficultyScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  sleepScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sleepScore', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  sleepScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sleepScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  sleepScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sleepScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  sleepScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sleepScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  stressScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stressScore', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  stressScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stressScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  stressScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stressScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  stressScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stressScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  suggestedGoalEqualTo(GoalType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'suggestedGoal', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  suggestedGoalGreaterThan(GoalType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'suggestedGoal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  suggestedGoalLessThan(GoalType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'suggestedGoal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  suggestedGoalBetween(
    GoalType lower,
    GoalType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'suggestedGoal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  timestampUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestampUtc', value: value),
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  timestampUtcLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterFilterCondition>
  timestampUtcBetween(
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
}

extension AssessmentResultQueryObject
    on QueryBuilder<AssessmentResult, AssessmentResult, QFilterCondition> {}

extension AssessmentResultQueryLinks
    on QueryBuilder<AssessmentResult, AssessmentResult, QFilterCondition> {}

extension AssessmentResultQuerySortBy
    on QueryBuilder<AssessmentResult, AssessmentResult, QSortBy> {
  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByAdhdScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adhdScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByAdhdScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adhdScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByAnxietyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anxietyScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByAnxietyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anxietyScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByDepressionScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depressionScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByDepressionScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depressionScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByFrequencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByFrequencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByRawAnswersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAnswersJson', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByRawAnswersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAnswersJson', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByRecoveryDifficultyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryDifficultyScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByRecoveryDifficultyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryDifficultyScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortBySuggestedGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedGoal', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortBySuggestedGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedGoal', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  sortByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }
}

extension AssessmentResultQuerySortThenBy
    on QueryBuilder<AssessmentResult, AssessmentResult, QSortThenBy> {
  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByAdhdScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adhdScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByAdhdScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adhdScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByAnxietyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anxietyScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByAnxietyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anxietyScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByDepressionScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depressionScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByDepressionScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depressionScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByFrequencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByFrequencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByRawAnswersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAnswersJson', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByRawAnswersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAnswersJson', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByRecoveryDifficultyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryDifficultyScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByRecoveryDifficultyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryDifficultyScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenBySuggestedGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedGoal', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenBySuggestedGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedGoal', Sort.desc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QAfterSortBy>
  thenByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }
}

extension AssessmentResultQueryWhereDistinct
    on QueryBuilder<AssessmentResult, AssessmentResult, QDistinct> {
  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByAdhdScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adhdScore');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByAnxietyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'anxietyScore');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByDepressionScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'depressionScore');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByFrequencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequencyScore');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct> distinctByPlanId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByRawAnswersJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'rawAnswersJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByRecoveryDifficultyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recoveryDifficultyScore');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepScore');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stressScore');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctBySuggestedGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suggestedGoal');
    });
  }

  QueryBuilder<AssessmentResult, AssessmentResult, QDistinct>
  distinctByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestampUtc');
    });
  }
}

extension AssessmentResultQueryProperty
    on QueryBuilder<AssessmentResult, AssessmentResult, QQueryProperty> {
  QueryBuilder<AssessmentResult, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AssessmentResult, int, QQueryOperations> adhdScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adhdScore');
    });
  }

  QueryBuilder<AssessmentResult, int, QQueryOperations> anxietyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'anxietyScore');
    });
  }

  QueryBuilder<AssessmentResult, int, QQueryOperations>
  depressionScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'depressionScore');
    });
  }

  QueryBuilder<AssessmentResult, int, QQueryOperations>
  frequencyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequencyScore');
    });
  }

  QueryBuilder<AssessmentResult, String, QQueryOperations> planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<AssessmentResult, String, QQueryOperations>
  rawAnswersJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawAnswersJson');
    });
  }

  QueryBuilder<AssessmentResult, int, QQueryOperations>
  recoveryDifficultyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recoveryDifficultyScore');
    });
  }

  QueryBuilder<AssessmentResult, int, QQueryOperations> sleepScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepScore');
    });
  }

  QueryBuilder<AssessmentResult, int, QQueryOperations> stressScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stressScore');
    });
  }

  QueryBuilder<AssessmentResult, GoalType, QQueryOperations>
  suggestedGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suggestedGoal');
    });
  }

  QueryBuilder<AssessmentResult, DateTime, QQueryOperations>
  timestampUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestampUtc');
    });
  }
}
