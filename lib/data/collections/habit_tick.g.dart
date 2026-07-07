// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_tick.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitTickCollection on Isar {
  IsarCollection<HabitTick> get habitTicks => this.collection();
}

const HabitTickSchema = CollectionSchema(
  name: r'HabitTick',
  id: -8380418752299710401,
  properties: {
    r'dateEpochDay': PropertySchema(
      id: 0,
      name: r'dateEpochDay',
      type: IsarType.long,
    ),
    r'habitId': PropertySchema(id: 1, name: r'habitId', type: IsarType.long),
  },

  estimateSize: _habitTickEstimateSize,
  serialize: _habitTickSerialize,
  deserialize: _habitTickDeserialize,
  deserializeProp: _habitTickDeserializeProp,
  idName: r'id',
  indexes: {
    r'habitId': IndexSchema(
      id: 1000409552522198739,
      name: r'habitId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'habitId',
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

  getId: _habitTickGetId,
  getLinks: _habitTickGetLinks,
  attach: _habitTickAttach,
  version: '3.3.2',
);

int _habitTickEstimateSize(
  HabitTick object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _habitTickSerialize(
  HabitTick object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateEpochDay);
  writer.writeLong(offsets[1], object.habitId);
}

HabitTick _habitTickDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitTick();
  object.dateEpochDay = reader.readLong(offsets[0]);
  object.habitId = reader.readLong(offsets[1]);
  object.id = id;
  return object;
}

P _habitTickDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitTickGetId(HabitTick object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitTickGetLinks(HabitTick object) {
  return [];
}

void _habitTickAttach(IsarCollection<dynamic> col, Id id, HabitTick object) {
  object.id = id;
}

extension HabitTickQueryWhereSort
    on QueryBuilder<HabitTick, HabitTick, QWhere> {
  QueryBuilder<HabitTick, HabitTick, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhere> anyHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'habitId'),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhere> anyDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateEpochDay'),
      );
    });
  }
}

extension HabitTickQueryWhere
    on QueryBuilder<HabitTick, HabitTick, QWhereClause> {
  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> idBetween(
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

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> habitIdEqualTo(
    int habitId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'habitId', value: [habitId]),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> habitIdNotEqualTo(
    int habitId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'habitId',
                lower: [],
                upper: [habitId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'habitId',
                lower: [habitId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'habitId',
                lower: [habitId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'habitId',
                lower: [],
                upper: [habitId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> habitIdGreaterThan(
    int habitId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'habitId',
          lower: [habitId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> habitIdLessThan(
    int habitId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'habitId',
          lower: [],
          upper: [habitId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> habitIdBetween(
    int lowerHabitId,
    int upperHabitId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'habitId',
          lower: [lowerHabitId],
          includeLower: includeLower,
          upper: [upperHabitId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> dateEpochDayEqualTo(
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

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> dateEpochDayNotEqualTo(
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

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> dateEpochDayGreaterThan(
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

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> dateEpochDayLessThan(
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

  QueryBuilder<HabitTick, HabitTick, QAfterWhereClause> dateEpochDayBetween(
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

extension HabitTickQueryFilter
    on QueryBuilder<HabitTick, HabitTick, QFilterCondition> {
  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> dateEpochDayEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateEpochDay', value: value),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition>
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

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition>
  dateEpochDayLessThan(int value, {bool include = false}) {
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

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> dateEpochDayBetween(
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

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> habitIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitId', value: value),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> habitIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> habitIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> habitIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HabitTick, HabitTick, QAfterFilterCondition> idBetween(
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
}

extension HabitTickQueryObject
    on QueryBuilder<HabitTick, HabitTick, QFilterCondition> {}

extension HabitTickQueryLinks
    on QueryBuilder<HabitTick, HabitTick, QFilterCondition> {}

extension HabitTickQuerySortBy on QueryBuilder<HabitTick, HabitTick, QSortBy> {
  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> sortByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> sortByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }
}

extension HabitTickQuerySortThenBy
    on QueryBuilder<HabitTick, HabitTick, QSortThenBy> {
  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> thenByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> thenByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitTick, HabitTick, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension HabitTickQueryWhereDistinct
    on QueryBuilder<HabitTick, HabitTick, QDistinct> {
  QueryBuilder<HabitTick, HabitTick, QDistinct> distinctByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateEpochDay');
    });
  }

  QueryBuilder<HabitTick, HabitTick, QDistinct> distinctByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId');
    });
  }
}

extension HabitTickQueryProperty
    on QueryBuilder<HabitTick, HabitTick, QQueryProperty> {
  QueryBuilder<HabitTick, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitTick, int, QQueryOperations> dateEpochDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateEpochDay');
    });
  }

  QueryBuilder<HabitTick, int, QQueryOperations> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }
}
