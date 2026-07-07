// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_definition.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitDefinitionCollection on Isar {
  IsarCollection<HabitDefinition> get habitDefinitions => this.collection();
}

const HabitDefinitionSchema = CollectionSchema(
  name: r'HabitDefinition',
  id: 970403525843598740,
  properties: {
    r'active': PropertySchema(id: 0, name: r'active', type: IsarType.bool),
    r'createdEpochDay': PropertySchema(
      id: 1,
      name: r'createdEpochDay',
      type: IsarType.long,
    ),
    r'sortOrder': PropertySchema(
      id: 2,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'title': PropertySchema(id: 3, name: r'title', type: IsarType.string),
    r'type': PropertySchema(
      id: 4,
      name: r'type',
      type: IsarType.byte,
      enumMap: _HabitDefinitiontypeEnumValueMap,
    ),
  },

  estimateSize: _habitDefinitionEstimateSize,
  serialize: _habitDefinitionSerialize,
  deserialize: _habitDefinitionDeserialize,
  deserializeProp: _habitDefinitionDeserializeProp,
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
  embeddedSchemas: {},

  getId: _habitDefinitionGetId,
  getLinks: _habitDefinitionGetLinks,
  attach: _habitDefinitionAttach,
  version: '3.3.2',
);

int _habitDefinitionEstimateSize(
  HabitDefinition object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _habitDefinitionSerialize(
  HabitDefinition object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeLong(offsets[1], object.createdEpochDay);
  writer.writeLong(offsets[2], object.sortOrder);
  writer.writeString(offsets[3], object.title);
  writer.writeByte(offsets[4], object.type.index);
}

HabitDefinition _habitDefinitionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitDefinition();
  object.active = reader.readBool(offsets[0]);
  object.createdEpochDay = reader.readLong(offsets[1]);
  object.id = id;
  object.sortOrder = reader.readLong(offsets[2]);
  object.title = reader.readString(offsets[3]);
  object.type =
      _HabitDefinitiontypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      HabitType.exercise;
  return object;
}

P _habitDefinitionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_HabitDefinitiontypeValueEnumMap[reader.readByteOrNull(offset)] ??
              HabitType.exercise)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HabitDefinitiontypeEnumValueMap = {
  'exercise': 0,
  'reading': 1,
  'meditation': 2,
  'prayer': 3,
  'sleep': 4,
  'water': 5,
  'eating': 6,
  'social': 7,
  'walk': 8,
  'gratitude': 9,
};
const _HabitDefinitiontypeValueEnumMap = {
  0: HabitType.exercise,
  1: HabitType.reading,
  2: HabitType.meditation,
  3: HabitType.prayer,
  4: HabitType.sleep,
  5: HabitType.water,
  6: HabitType.eating,
  7: HabitType.social,
  8: HabitType.walk,
  9: HabitType.gratitude,
};

Id _habitDefinitionGetId(HabitDefinition object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitDefinitionGetLinks(HabitDefinition object) {
  return [];
}

void _habitDefinitionAttach(
  IsarCollection<dynamic> col,
  Id id,
  HabitDefinition object,
) {
  object.id = id;
}

extension HabitDefinitionQueryWhereSort
    on QueryBuilder<HabitDefinition, HabitDefinition, QWhere> {
  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhere> anyActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'active'),
      );
    });
  }
}

extension HabitDefinitionQueryWhere
    on QueryBuilder<HabitDefinition, HabitDefinition, QWhereClause> {
  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhereClause>
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhereClause> idBetween(
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhereClause>
  activeEqualTo(bool active) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'active', value: [active]),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterWhereClause>
  activeNotEqualTo(bool active) {
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

extension HabitDefinitionQueryFilter
    on QueryBuilder<HabitDefinition, HabitDefinition, QFilterCondition> {
  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  activeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'active', value: value),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  createdEpochDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdEpochDay', value: value),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  createdEpochDayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdEpochDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  createdEpochDayLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdEpochDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  createdEpochDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdEpochDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sortOrder', value: value),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  sortOrderGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sortOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  sortOrderLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sortOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  sortOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sortOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleGreaterThan(
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleLessThan(
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleBetween(
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  typeEqualTo(HabitType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  typeGreaterThan(HabitType value, {bool include = false}) {
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  typeLessThan(HabitType value, {bool include = false}) {
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

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterFilterCondition>
  typeBetween(
    HabitType lower,
    HabitType upper, {
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

extension HabitDefinitionQueryObject
    on QueryBuilder<HabitDefinition, HabitDefinition, QFilterCondition> {}

extension HabitDefinitionQueryLinks
    on QueryBuilder<HabitDefinition, HabitDefinition, QFilterCondition> {}

extension HabitDefinitionQuerySortBy
    on QueryBuilder<HabitDefinition, HabitDefinition, QSortBy> {
  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  sortByCreatedEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdEpochDay', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  sortByCreatedEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdEpochDay', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension HabitDefinitionQuerySortThenBy
    on QueryBuilder<HabitDefinition, HabitDefinition, QSortThenBy> {
  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  thenByCreatedEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdEpochDay', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  thenByCreatedEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdEpochDay', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension HabitDefinitionQueryWhereDistinct
    on QueryBuilder<HabitDefinition, HabitDefinition, QDistinct> {
  QueryBuilder<HabitDefinition, HabitDefinition, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QDistinct>
  distinctByCreatedEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdEpochDay');
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QDistinct>
  distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitDefinition, HabitDefinition, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension HabitDefinitionQueryProperty
    on QueryBuilder<HabitDefinition, HabitDefinition, QQueryProperty> {
  QueryBuilder<HabitDefinition, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitDefinition, bool, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<HabitDefinition, int, QQueryOperations>
  createdEpochDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdEpochDay');
    });
  }

  QueryBuilder<HabitDefinition, int, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<HabitDefinition, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<HabitDefinition, HabitType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
