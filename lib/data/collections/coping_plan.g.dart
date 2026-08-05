// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coping_plan.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCopingPlanCollection on Isar {
  IsarCollection<CopingPlan> get copingPlans => this.collection();
}

const CopingPlanSchema = CollectionSchema(
  name: r'CopingPlan',
  id: 160833852469863689,
  properties: {
    r'createdAtUtc': PropertySchema(
      id: 0,
      name: r'createdAtUtc',
      type: IsarType.dateTime,
    ),
    r'need': PropertySchema(id: 1, name: r'need', type: IsarType.string),
    r'strategy': PropertySchema(
      id: 2,
      name: r'strategy',
      type: IsarType.string,
    ),
    r'supersededAtUtc': PropertySchema(
      id: 3,
      name: r'supersededAtUtc',
      type: IsarType.dateTime,
    ),
    r'trigger': PropertySchema(
      id: 4,
      name: r'trigger',
      type: IsarType.byte,
      enumMap: _CopingPlantriggerEnumValueMap,
    ),
  },

  estimateSize: _copingPlanEstimateSize,
  serialize: _copingPlanSerialize,
  deserialize: _copingPlanDeserialize,
  deserializeProp: _copingPlanDeserializeProp,
  idName: r'id',
  indexes: {
    r'trigger': IndexSchema(
      id: -9206707463460544926,
      name: r'trigger',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'trigger',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'createdAtUtc': IndexSchema(
      id: 4429811816233625579,
      name: r'createdAtUtc',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAtUtc',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _copingPlanGetId,
  getLinks: _copingPlanGetLinks,
  attach: _copingPlanAttach,
  version: '3.3.2',
);

int _copingPlanEstimateSize(
  CopingPlan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.need;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.strategy.length * 3;
  return bytesCount;
}

void _copingPlanSerialize(
  CopingPlan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAtUtc);
  writer.writeString(offsets[1], object.need);
  writer.writeString(offsets[2], object.strategy);
  writer.writeDateTime(offsets[3], object.supersededAtUtc);
  writer.writeByte(offsets[4], object.trigger.index);
}

CopingPlan _copingPlanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CopingPlan();
  object.createdAtUtc = reader.readDateTime(offsets[0]);
  object.id = id;
  object.need = reader.readStringOrNull(offsets[1]);
  object.strategy = reader.readString(offsets[2]);
  object.supersededAtUtc = reader.readDateTimeOrNull(offsets[3]);
  object.trigger =
      _CopingPlantriggerValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      TriggerType.time;
  return object;
}

P _copingPlanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (_CopingPlantriggerValueEnumMap[reader.readByteOrNull(offset)] ??
              TriggerType.time)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CopingPlantriggerEnumValueMap = {
  'time': 0,
  'location': 1,
  'emotion': 2,
  'device': 3,
  'website': 4,
  'stress': 5,
  'boredom': 6,
  'loneliness': 7,
  'anger': 8,
  'rejection': 9,
  'alcohol': 10,
  'socialMedia': 11,
  'tiredness': 12,
};
const _CopingPlantriggerValueEnumMap = {
  0: TriggerType.time,
  1: TriggerType.location,
  2: TriggerType.emotion,
  3: TriggerType.device,
  4: TriggerType.website,
  5: TriggerType.stress,
  6: TriggerType.boredom,
  7: TriggerType.loneliness,
  8: TriggerType.anger,
  9: TriggerType.rejection,
  10: TriggerType.alcohol,
  11: TriggerType.socialMedia,
  12: TriggerType.tiredness,
};

Id _copingPlanGetId(CopingPlan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _copingPlanGetLinks(CopingPlan object) {
  return [];
}

void _copingPlanAttach(IsarCollection<dynamic> col, Id id, CopingPlan object) {
  object.id = id;
}

extension CopingPlanQueryWhereSort
    on QueryBuilder<CopingPlan, CopingPlan, QWhere> {
  QueryBuilder<CopingPlan, CopingPlan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhere> anyTrigger() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'trigger'),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhere> anyCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAtUtc'),
      );
    });
  }
}

extension CopingPlanQueryWhere
    on QueryBuilder<CopingPlan, CopingPlan, QWhereClause> {
  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> idBetween(
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

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> triggerEqualTo(
    TriggerType trigger,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'trigger', value: [trigger]),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> triggerNotEqualTo(
    TriggerType trigger,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trigger',
                lower: [],
                upper: [trigger],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trigger',
                lower: [trigger],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trigger',
                lower: [trigger],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trigger',
                lower: [],
                upper: [trigger],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> triggerGreaterThan(
    TriggerType trigger, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'trigger',
          lower: [trigger],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> triggerLessThan(
    TriggerType trigger, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'trigger',
          lower: [],
          upper: [trigger],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> triggerBetween(
    TriggerType lowerTrigger,
    TriggerType upperTrigger, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'trigger',
          lower: [lowerTrigger],
          includeLower: includeLower,
          upper: [upperTrigger],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> createdAtUtcEqualTo(
    DateTime createdAtUtc,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'createdAtUtc',
          value: [createdAtUtc],
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause>
  createdAtUtcNotEqualTo(DateTime createdAtUtc) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAtUtc',
                lower: [],
                upper: [createdAtUtc],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAtUtc',
                lower: [createdAtUtc],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAtUtc',
                lower: [createdAtUtc],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAtUtc',
                lower: [],
                upper: [createdAtUtc],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause>
  createdAtUtcGreaterThan(DateTime createdAtUtc, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAtUtc',
          lower: [createdAtUtc],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> createdAtUtcLessThan(
    DateTime createdAtUtc, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAtUtc',
          lower: [],
          upper: [createdAtUtc],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterWhereClause> createdAtUtcBetween(
    DateTime lowerCreatedAtUtc,
    DateTime upperCreatedAtUtc, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAtUtc',
          lower: [lowerCreatedAtUtc],
          includeLower: includeLower,
          upper: [upperCreatedAtUtc],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CopingPlanQueryFilter
    on QueryBuilder<CopingPlan, CopingPlan, QFilterCondition> {
  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  createdAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAtUtc', value: value),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  createdAtUtcGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  createdAtUtcLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  createdAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAtUtc',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'need'),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'need'),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'need',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'need',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'need',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'need',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'need',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'need',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'need',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'need',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'need', value: ''),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> needIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'need', value: ''),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> strategyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'strategy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  strategyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'strategy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> strategyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'strategy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> strategyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'strategy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  strategyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'strategy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> strategyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'strategy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> strategyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'strategy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> strategyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'strategy',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  strategyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'strategy', value: ''),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  strategyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'strategy', value: ''),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  supersededAtUtcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'supersededAtUtc'),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  supersededAtUtcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'supersededAtUtc'),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  supersededAtUtcEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supersededAtUtc', value: value),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  supersededAtUtcGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'supersededAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  supersededAtUtcLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'supersededAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  supersededAtUtcBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'supersededAtUtc',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> triggerEqualTo(
    TriggerType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trigger', value: value),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition>
  triggerGreaterThan(TriggerType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'trigger',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> triggerLessThan(
    TriggerType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'trigger',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterFilterCondition> triggerBetween(
    TriggerType lower,
    TriggerType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'trigger',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CopingPlanQueryObject
    on QueryBuilder<CopingPlan, CopingPlan, QFilterCondition> {}

extension CopingPlanQueryLinks
    on QueryBuilder<CopingPlan, CopingPlan, QFilterCondition> {}

extension CopingPlanQuerySortBy
    on QueryBuilder<CopingPlan, CopingPlan, QSortBy> {
  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByCreatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByNeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'need', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByNeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'need', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByStrategy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByStrategyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortBySupersededAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersededAtUtc', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy>
  sortBySupersededAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersededAtUtc', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByTrigger() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trigger', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> sortByTriggerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trigger', Sort.desc);
    });
  }
}

extension CopingPlanQuerySortThenBy
    on QueryBuilder<CopingPlan, CopingPlan, QSortThenBy> {
  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByCreatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByNeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'need', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByNeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'need', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByStrategy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByStrategyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenBySupersededAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersededAtUtc', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy>
  thenBySupersededAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersededAtUtc', Sort.desc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByTrigger() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trigger', Sort.asc);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QAfterSortBy> thenByTriggerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trigger', Sort.desc);
    });
  }
}

extension CopingPlanQueryWhereDistinct
    on QueryBuilder<CopingPlan, CopingPlan, QDistinct> {
  QueryBuilder<CopingPlan, CopingPlan, QDistinct> distinctByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtUtc');
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QDistinct> distinctByNeed({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'need', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QDistinct> distinctByStrategy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strategy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QDistinct> distinctBySupersededAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supersededAtUtc');
    });
  }

  QueryBuilder<CopingPlan, CopingPlan, QDistinct> distinctByTrigger() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trigger');
    });
  }
}

extension CopingPlanQueryProperty
    on QueryBuilder<CopingPlan, CopingPlan, QQueryProperty> {
  QueryBuilder<CopingPlan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CopingPlan, DateTime, QQueryOperations> createdAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtUtc');
    });
  }

  QueryBuilder<CopingPlan, String?, QQueryOperations> needProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'need');
    });
  }

  QueryBuilder<CopingPlan, String, QQueryOperations> strategyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strategy');
    });
  }

  QueryBuilder<CopingPlan, DateTime?, QQueryOperations>
  supersededAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supersededAtUtc');
    });
  }

  QueryBuilder<CopingPlan, TriggerType, QQueryOperations> triggerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trigger');
    });
  }
}
