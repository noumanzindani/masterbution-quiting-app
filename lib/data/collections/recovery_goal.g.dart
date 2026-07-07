// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_goal.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecoveryGoalCollection on Isar {
  IsarCollection<RecoveryGoal> get recoveryGoals => this.collection();
}

const RecoveryGoalSchema = CollectionSchema(
  name: r'RecoveryGoal',
  id: 4233239125159860196,
  properties: {
    r'active': PropertySchema(id: 0, name: r'active', type: IsarType.bool),
    r'milestones': PropertySchema(
      id: 1,
      name: r'milestones',
      type: IsarType.objectList,

      target: r'Milestone',
    ),
    r'startDate': PropertySchema(
      id: 2,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'target': PropertySchema(
      id: 3,
      name: r'target',
      type: IsarType.byte,
      enumMap: _RecoveryGoaltargetEnumValueMap,
    ),
    r'targetDays': PropertySchema(
      id: 4,
      name: r'targetDays',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _RecoveryGoaltypeEnumValueMap,
    ),
  },

  estimateSize: _recoveryGoalEstimateSize,
  serialize: _recoveryGoalSerialize,
  deserialize: _recoveryGoalDeserialize,
  deserializeProp: _recoveryGoalDeserializeProp,
  idName: r'id',
  indexes: {
    r'active': IndexSchema(
      id: -7515327150349743717,
      name: r'active',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'active',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'Milestone': MilestoneSchema},

  getId: _recoveryGoalGetId,
  getLinks: _recoveryGoalGetLinks,
  attach: _recoveryGoalAttach,
  version: '3.3.2',
);

int _recoveryGoalEstimateSize(
  RecoveryGoal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.milestones.length * 3;
  {
    final offsets = allOffsets[Milestone]!;
    for (var i = 0; i < object.milestones.length; i++) {
      final value = object.milestones[i];
      bytesCount += MilestoneSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _recoveryGoalSerialize(
  RecoveryGoal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeObjectList<Milestone>(
    offsets[1],
    allOffsets,
    MilestoneSchema.serialize,
    object.milestones,
  );
  writer.writeDateTime(offsets[2], object.startDate);
  writer.writeByte(offsets[3], object.target.index);
  writer.writeLong(offsets[4], object.targetDays);
  writer.writeByte(offsets[5], object.type.index);
}

RecoveryGoal _recoveryGoalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecoveryGoal();
  object.active = reader.readBool(offsets[0]);
  object.id = id;
  object.milestones =
      reader.readObjectList<Milestone>(
        offsets[1],
        MilestoneSchema.deserialize,
        allOffsets,
        Milestone(),
      ) ??
      [];
  object.startDate = reader.readDateTime(offsets[2]);
  object.target =
      _RecoveryGoaltargetValueEnumMap[reader.readByteOrNull(offsets[3])] ??
      BehaviorTarget.porn;
  object.targetDays = reader.readLong(offsets[4]);
  object.type =
      _RecoveryGoaltypeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
      GoalType.quitPorn;
  return object;
}

P _recoveryGoalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readObjectList<Milestone>(
                offset,
                MilestoneSchema.deserialize,
                allOffsets,
                Milestone(),
              ) ??
              [])
          as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (_RecoveryGoaltargetValueEnumMap[reader.readByteOrNull(offset)] ??
              BehaviorTarget.porn)
          as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (_RecoveryGoaltypeValueEnumMap[reader.readByteOrNull(offset)] ??
              GoalType.quitPorn)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RecoveryGoaltargetEnumValueMap = {
  'porn': 0,
  'masturbation': 1,
  'both': 2,
  'none': 3,
};
const _RecoveryGoaltargetValueEnumMap = {
  0: BehaviorTarget.porn,
  1: BehaviorTarget.masturbation,
  2: BehaviorTarget.both,
  3: BehaviorTarget.none,
};
const _RecoveryGoaltypeEnumValueMap = {
  'quitPorn': 0,
  'quitMasturbation': 1,
  'reduceFrequency': 2,
  'healthyHabits': 3,
};
const _RecoveryGoaltypeValueEnumMap = {
  0: GoalType.quitPorn,
  1: GoalType.quitMasturbation,
  2: GoalType.reduceFrequency,
  3: GoalType.healthyHabits,
};

Id _recoveryGoalGetId(RecoveryGoal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recoveryGoalGetLinks(RecoveryGoal object) {
  return [];
}

void _recoveryGoalAttach(
  IsarCollection<dynamic> col,
  Id id,
  RecoveryGoal object,
) {
  object.id = id;
}

extension RecoveryGoalQueryWhereSort
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QWhere> {
  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhere> anyActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'active'),
      );
    });
  }
}

extension RecoveryGoalQueryWhere
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QWhereClause> {
  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhereClause> idBetween(
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

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhereClause> activeEqualTo(
    bool active,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'active', value: [active]),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterWhereClause> activeNotEqualTo(
    bool active,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'active',
                lower: [],
                upper: [active],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'active',
                lower: [active],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'active',
                lower: [active],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'active',
                lower: [],
                upper: [active],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension RecoveryGoalQueryFilter
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QFilterCondition> {
  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> activeEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'active', value: value),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  milestonesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'milestones', length, true, length, true);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  milestonesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'milestones', 0, true, 0, true);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  milestonesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'milestones', 0, false, 999999, true);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  milestonesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'milestones', 0, true, length, include);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  milestonesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'milestones', length, include, 999999, true);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  milestonesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'milestones',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: value),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  startDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  startDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> targetEqualTo(
    BehaviorTarget value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'target', value: value),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  targetGreaterThan(BehaviorTarget value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'target',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  targetLessThan(BehaviorTarget value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'target',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> targetBetween(
    BehaviorTarget lower,
    BehaviorTarget upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'target',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  targetDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetDays', value: value),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  targetDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  targetDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  targetDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> typeEqualTo(
    GoalType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  typeGreaterThan(GoalType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> typeLessThan(
    GoalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition> typeBetween(
    GoalType lower,
    GoalType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RecoveryGoalQueryObject
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QFilterCondition> {
  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterFilterCondition>
  milestonesElement(FilterQuery<Milestone> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'milestones');
    });
  }
}

extension RecoveryGoalQueryLinks
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QFilterCondition> {}

extension RecoveryGoalQuerySortBy
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QSortBy> {
  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByTargetDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy>
  sortByTargetDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension RecoveryGoalQuerySortThenBy
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QSortThenBy> {
  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByTargetDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy>
  thenByTargetDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.desc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension RecoveryGoalQueryWhereDistinct
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QDistinct> {
  QueryBuilder<RecoveryGoal, RecoveryGoal, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QDistinct> distinctByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'target');
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QDistinct> distinctByTargetDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDays');
    });
  }

  QueryBuilder<RecoveryGoal, RecoveryGoal, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension RecoveryGoalQueryProperty
    on QueryBuilder<RecoveryGoal, RecoveryGoal, QQueryProperty> {
  QueryBuilder<RecoveryGoal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecoveryGoal, bool, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<RecoveryGoal, List<Milestone>, QQueryOperations>
  milestonesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'milestones');
    });
  }

  QueryBuilder<RecoveryGoal, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<RecoveryGoal, BehaviorTarget, QQueryOperations>
  targetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'target');
    });
  }

  QueryBuilder<RecoveryGoal, int, QQueryOperations> targetDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDays');
    });
  }

  QueryBuilder<RecoveryGoal, GoalType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MilestoneSchema = Schema(
  name: r'Milestone',
  id: -9151650993853299783,
  properties: {
    r'day': PropertySchema(id: 0, name: r'day', type: IsarType.long),
    r'label': PropertySchema(id: 1, name: r'label', type: IsarType.string),
    r'reached': PropertySchema(id: 2, name: r'reached', type: IsarType.bool),
    r'reachedAt': PropertySchema(
      id: 3,
      name: r'reachedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _milestoneEstimateSize,
  serialize: _milestoneSerialize,
  deserialize: _milestoneDeserialize,
  deserializeProp: _milestoneDeserializeProp,
);

int _milestoneEstimateSize(
  Milestone object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.label.length * 3;
  return bytesCount;
}

void _milestoneSerialize(
  Milestone object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.day);
  writer.writeString(offsets[1], object.label);
  writer.writeBool(offsets[2], object.reached);
  writer.writeDateTime(offsets[3], object.reachedAt);
}

Milestone _milestoneDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Milestone();
  object.day = reader.readLong(offsets[0]);
  object.label = reader.readString(offsets[1]);
  object.reached = reader.readBool(offsets[2]);
  object.reachedAt = reader.readDateTimeOrNull(offsets[3]);
  return object;
}

P _milestoneDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MilestoneQueryFilter
    on QueryBuilder<Milestone, Milestone, QFilterCondition> {
  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> dayEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'day', value: value),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> dayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'day',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> dayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'day',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> dayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'day',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'label',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'label',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'label', value: ''),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'label', value: ''),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> reachedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reached', value: value),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> reachedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reachedAt'),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition>
  reachedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reachedAt'),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> reachedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reachedAt', value: value),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition>
  reachedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> reachedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Milestone, Milestone, QAfterFilterCondition> reachedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reachedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MilestoneQueryObject
    on QueryBuilder<Milestone, Milestone, QFilterCondition> {}
