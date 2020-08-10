
## @knitr INTRODUCTION_EXAMPLE_DATA
## INTRODUCTION --------------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr data1.3
import pandas as pd
import numpy as np

## Create a pandas DataFrame
DF = pd.DataFrame(
  {"V1" : [1, 2, 1, 2, 1, 2, 1, 2, 1],
   "V2" : [1, 2, 3, 4, 5, 6, 7, 8, 9], 
   "V3" : [0.5, 1.0, 1.5] * 3, 
   "V4" : ['A', 'B', 'C'] * 3}) 
type(DF)
DF



## @knitr BASICS
## BASIC OPERATIONS ----------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr filterRows
## Filter rows ---------------------------------------------------------

## @knitr filterRows1.3
DF.iloc[2:4]

## @knitr filterRows2.3
DF[~DF.index.isin(range(2, 7))]

## @knitr filterRows3.3
DF[DF.V2 > 5]
DF.query('V2>5')
DF[DF.V4.isin(['A', 'C'])]

## @knitr filterRows4.3
DF.loc[(DF.V1 == 1) & (DF.V4 == 'A')]
# DF.query("V1 == 1 and V4 == 'A'")
# any logical criteria can be used

## @knitr filterRows5.3
DF.drop_duplicates()
DF.drop_duplicates(subset =['V1', 'V4'])

## @knitr filterRows6.3
DF.dropna(subset = DF.columns)
# dropna has more options
DF.dropna(axis = 0, how = 'any', thresh = None, subset = None, inplace = False)

## @knitr filterRows7.3
DF.sample(n = 3)
DF.sample(frac = 0.5)
# DF[DF['V1'].nlargest(1)] # no keep = 'all'

# @knitr filterRows8.3
DF[DF.V4.str.startswith('B')] # use tuples when multiple
DF[DF['V2'].between(3, 5)]
DF[DF['V2'].between(3, 5, inclusive = False)]
#DF[DF.V2 >= list(range(-1, 2)) & DF.V2 <= list(range(1,4))]


## @knitr sortRows
## Sort rows -----------------------------------------------------------

## @knitr sortRows1.3
DF.sort_values('V3')

## @knitr sortRows2.3
DF.sort_values('V3', ascending = False)

## @knitr sortRows3.3
DF.sort_values(['V1', 'V2'], ascending = [True, False])


## @knitr selectCols
## Select columns ------------------------------------------------------

## @knitr selectCols1.3
DF.iloc[:, 2]   # returns a pandas Series
DF.iloc[:, [2]] # convert to DataFrame


## @knitr selectCols2.3
DF.V2           # returns a pandas Series
DF['V2']        # returns a pandas Series
DF.loc[:, 'V2'] # returns a pandas Series
DF[['V2']]      # returns a DataFrame

## @knitr selectCols3.3
DF[['V2', 'V3', 'V4']]
DF.loc[:, 'V2':'V4'] # select columns between V2 and V4

## @knitr selectCols4.3
DF.drop(columns = ['V2', 'V3'])

## @knitr selectCols5.3
cols = ['V2', 'V3']
DF.loc[:, cols]
DF.loc[:, DF.columns.difference(cols)]

## @knitr selectCols6.3
cols = ['V' + str(x) for x in [1, 2]] # and DF.loc
# ?
DF.filter(regex = 'V')
DF.filter(regex = '3$')
DF.filter(regex = '.2')
DF.filter(regex = '^V1|X$')
DF.filter(regex = '^(?!V2)')


## @knitr summarise
## Summarise data ------------------------------------------------------

## @knitr summarise1.3
DF.V1.sum()   # returns a numpy array
DF[['V1']].sum()   # returns a pandas series
DF.loc[:, ['V1']].agg(['sum']).set_axis(['sumV1'], axis = 1)

## @knitr summarise2.3
DF.agg({'V1': 'sum', 'V3': 'std'}) # series

## @knitr summarise3.3
DF.agg(sumV1 = ('V1','sum'), sdv3 = ('V3','std'))
#res = list(DF.agg({'V1': 'sum', 'V3': 'std'}))
#pd.DataFrame([res], columns=['sumV1','sdv3'])

## @knitr summarise4.3
DF.loc[:3, 'V1'].sum()

## @knitr summarise5.3
DF.loc[0,'V3']
DF.at[DF.index[-1], 'V3']
# at method better than loc with scalars
DF.V3.iloc[4]
DF['V4'].nunique()
len(DF.drop_duplicates())


## @knitr cols
## Add/Update/Delete columns --------------------------------------------

## @knitr cols1.3
DF.loc[:, 'V1'] = DF.loc[:, 'V1'] ** 2
#DF['V1'] = DF['V1']**2
DF.eval('V1 = V1**2', inplace = True)
DF

## @knitr cols2.3
DF = DF.assign(v5 = np.log(DF.V1))

## @knitr cols3.3
DF = DF.assign(v6 = np.sqrt(DF.V1), v7 = 'X')

## @knitr cols4.3
DF.loc[:, ['V3']].add(1).rename(columns = {'V3':'V8'})
# pd.DataFrame({'v8' : DF.V3 + 1})

## @knitr cols5.3
del DF['v5'] # DF = DF.drop('v5', 1)

## @knitr cols6.3
DF = DF.drop(['v6', 'v7'], 1)

## @knitr cols7.3
cols = 'V3'
del DF[cols]

## @knitr cols8.3
DF.loc[DF.loc[:, 'V2'] < 4, 'V2'] = 0


## @knitr by
## by ------------------------------------------------------------------

## @knitr by1.3
(DF.groupby(['V4'], as_index = False)
  .agg(sumV2 = ('V2', 'sum')))

## @knitr by2.3
(DF.groupby(['V4', 'V1'], as_index = False)
  .agg(sumV2 = ('V2', 'sum')))

## @knitr by3.3
(DF.assign(V4 = DF.V4.str.lower())
  .groupby(['V4'], as_index = False)
  .agg(sumV1=('V1', 'sum')))

## @knitr by4.3
(DF.assign(abc = lambda x: x.V4.str.lower())
  .groupby(['abc'], as_index = False)
  .agg(sumV1 = ('V1', 'sum')))

## @knitr by5.3
DF.groupby(DF.V4 == 'A').V1.sum()

## @knitr by6.3
DF.iloc[:5].groupby('V4').agg(sumV1 = ('V1','sum'))

## @knitr by7.3
DF.groupby('V4').size()

## @knitr by8.3
DF.assign(n = lambda x: x.groupby('V1').V4.transform('count'))

## @knitr by9.3
DF.groupby('V4')['V2'].first()
DF.groupby('V4')['V2'].last()
DF.groupby('V4')['V2'].nth(1) # 0-based



## @knitr GOING_FURTHER
## GOING_FURTHER -------------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr advCols
## Advanced columns manipulation ---------------------------------------

## @knitr advCols1.3
DF.agg(['max'])

## @knitr advCols2.3
DF.loc[:, ['V1', 'V2']].agg(['mean'])

## @knitr advCols3.3
(DF.groupby('V4')
  .agg(**{f'{col}_mean':(col, 'mean') for col in ['V1', 'V2']}))
## using regex
(DF.filter(regex=('V1|V2|V4'))
   .groupby('V4')
   .apply(np.mean, axis = 0)
   .reset_index())

## @knitr advCols4.3
DF.groupby('V4').agg(['sum', 'mean'])

## @knitr advCols5.3
DF.select_dtypes(include = 'number').agg(['mean'])

## @knitr advCols6.3
DF.iloc[::-1]
#DF.apply(lambda x: x[::-1], axis = 0)

## @knitr advCols7.3
DF.filter(['V1', 'V2']).agg(np.sqrt)
DF.filter(regex = '[^V4]').agg(np.exp)

## @knitr advCols8.3
DF.loc[:, 'V1':'V2'] = DF.filter(['V1', 'V2']).agg(np.sqrt)
cols = DF.columns.difference(['V4'])
DF.loc[:, cols] = DF.filter(cols).agg(lambda x: pow(x,2))
DF

## @knitr advCols9.3
DF.select_dtypes("number").sub(1)
#cols = DF.select_dtypes(include = [np.number]).columns
#DF.loc[:, cols].apply(lambda x: x - 1)

## @knitr advCols10.3
DF.loc[:, cols] = DF.loc[:, cols].astype(int)
DF

## @knitr advCols11.3
(DF.groupby('V4')
  .head(2)
  .assign(V2 = 'X')
  .sort_values('V4'))
## @knitr advCols12.3
pass


## @knitr chaining
## Chain expressions ---------------------------------------------------

## @knitr chain1.3
(DF.groupby(['V4'], as_index=False)
  .agg(V1sum = ('V1',np.sum))
  .query('V1sum > 5'))

## @knitr chain2.3
pass

## @knitr key
## Indexing and Keys ----------------------------------------------------

## @knitr key1.3
DF.set_index('V4', drop = False, inplace = True)
DF.sort_index(inplace = True)
DF

## @knitr key2.3
DF.loc['A']
DF.loc[['A', 'C']]

## @knitr key3.3
DF.loc['B'].head(1)
# ?

## @knitr key4.3
DF.loc['A'].tail(1)

## @knitr key5.3
#deprecate-loc-reindex-listlike
#DF.loc[['A', 'D']]
#DF.loc[['A', 'D']].dropna()


## @knitr key6.3
DF.loc[['A', 'C'],'V1'].sum() 

## @knitr key7.3
DF.loc['A', 'V1'] = 0
DF

## @knitr key8.3
(DF.query("index != 'B'")
  .groupby(level=0)
  .agg({'V1':np.sum}))
#DF.loc[~(DF.index == 'B')].groupby(level = 0).agg({'V1':'sum'})

## @knitr key9.3
DF.set_index(['V4', 'V1'], drop = False, inplace = True)
DF.sort_index(inplace = True)
DF

## @knitr key10.3
DF.loc[('C', 1)]
DF.loc[(('B', 'C'), 1), :]
#DF.query("V4 in ('B', 'C') and V1 == 1")
list(np.where(DF.V4.isin(['B', 'C']) & DF.V1 == 1))
DF.index.isin({'V4': ['B', 'C'], 'V1': [1]}) # wrong

## @knitr key11.3
DF.reset_index(inplace = True, drop = True)
DF

## @knitr set
## set* modifications ----------------------------------------------------

## @knitr set1.3
DF.iloc[0, 1] = 3
DF

## @knitr set2.3
DF.sort_values(['V4','V1'], ascending = [True, False], inplace = True)

## @knitr set3.3
DF.rename(columns = {'V2':'v2'}, inplace = True)
cols = DF.columns.values; cols[1] = 'V2'
DF.columns = cols
DF

## @knitr set4.3
DF = DF[['V4', 'V1', 'V2']]
DF

## @knitr set5.3
pass


## @knitr advBy
## Advanced use of by ----------------------------------------------------

## @knitr advBy1.3
DF.groupby('V4').head(1)
DF.groupby('V4').nth([0, -1])
DF.groupby('V4').nth([-1, -2])

## @knitr advBy2.3
DF.loc[DF.groupby('V4').V2.idxmin()]

## @knitr advBy3.3
DF['Grp'] = DF.groupby(['V4', 'V1']).ngroup()
DF
del DF['Grp']

## @knitr advBy4.3
pd.DataFrame(DF.groupby('V4').indices).melt()
pd.DataFrame(DF.groupby('V4').indices).loc[0]
pd.DataFrame(DF.groupby('V4').indices).iloc[[0,-1]].melt()

## @knitr advBy5.3
DF.groupby('V4')['V1'].apply(list)
# ?

## @knitr advBy6.3
dd = pd.pivot_table(DF, values=['V2'], \
        index =['V1'], columns=['V4'], aggfunc = np.sum, margins = True)
pd.melt(dd, col_level = 1)
# ?


## @knitr MISCELLANEOUS
## MISCELLANEOUS --------------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr readwrite
## Read/write data ------------------------------------------------------

## @knitr readwrite1.3
DF.to_csv('DF.csv', index = False)

## @knitr readwrite2.3
DF.to_csv('DF.txt', sep='\t', index = False)

## @knitr readwrite3.3
pd.DataFrame({'V1':0, 'V2':[[1,2,3,4,5]]}).to_csv('DF2.csv', index = False)

## @knitr readwrite4.3
pd.read_csv('DF.csv')
pd.read_csv('DF.txt', sep = '\t')

## @knitr readwrite5.3
pd.read_csv('DF.csv', usecols=['V1', 'V4'])
pd.read_csv('DF.csv', usecols = lambda x: x != 'V4')

## @knitr readwrite6.3
li = [pd.read_csv(fi) for fi in ['DF.csv', 'DF.csv']]
pd.concat(li, axis = 0, ignore_index = True)


## @knitr reshape
## Reshape data ---------------------------------------------------------

## @knitr reshape1.3
pd.melt(DF, id_vars = ['V4'])
mDF = pd.melt(DF,
              id_vars    = 'V4',
              value_vars = ('V1', 'V2'), 
              var_name   = 'Variable',
              value_name = 'Value')

## @knitr reshape2.3
pd.crosstab(mDF.V4, mDF.Variable)
pd.crosstab(mDF.V4, mDF.Variable, values = mDF.Value, aggfunc = 'sum')
pd.crosstab(mDF.V4, mDF.Value > 5)

## @knitr reshape3.3
list(DF.groupby('V4'))

## @knitr reshape4.3
vec = ['A:a', 'B:b', 'C:c']
[i.split(':')[1] for i in vec]
pd.DataFrame([i.split(':') for i in vec])


## @knitr other
## Other ----------------------------------------------------------------

## @knitr other1.3
pass

## @knitr other2.3
# %whos DataFrame # IPython
for i in dir():
    if type(globals()[i]) == pd.DataFrame:
        print(i)

## @knitr other3.3
pass

## @knitr other4.3
pd.Series(np.arange(1, 11)).shift(periods = 1)
[pd.Series(np.arange(1, 11)).shift(periods = i) for i in [1,2]]
pd.Series(np.arange(1, 11)).shift(periods = -1)

## @knitr other5.3
pass

## @knitr other6.3
pass

## @knitr other7.3
pass



## @knitr JOINS
## JOIN/BIND DATASETS ---------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr join
## Join -----------------------------------------------------------------

## @knitr join1.3
x = pd.DataFrame(
  {"Id" : ['A', 'B', 'C', 'C'],
   "X1" : [1, 3, 5, 7],
   "XY" : ['x2', 'x4', 'x6', 'x8']})
y = pd.DataFrame(
  {"Id" : ['A', 'B', 'B', 'D'],
   "Y1" : [1, 3, 5, 7],
   "XY" : ['y1', 'y3', 'y5', 'y7']})

## @knitr join2.3
pd.merge(x, y, how = 'left', on = 'Id')

## @knitr join3.3
pd.merge(x, y, how = 'right', on = 'Id')

## @knitr join4.3
pd.merge(x, y, how = 'inner', on = 'Id')

## @knitr join5.3
pd.merge(x, y, how = 'outer', on = 'Id')

## @knitr join6.3
x[x.Id.isin(y.Id)]

## @knitr join7.3
x[~x.Id.isin(y.Id)]


## @knitr morejoins
## More join -------------------------------------------------------------

## @knitr morejoins1.3
pd.merge(x[['Id','X1']],
         y[['Id','XY']],
         how = 'right',
         on  = 'Id')
pd.merge(x[['Id','XY']],
         y[['Id','XY']],
         how = 'right',
         on  = 'Id')

## @knitr morejoins2.3
(y.groupby('Id')['Y1']
    .agg('sum')
    .to_frame()
    .rename(columns={'Y1': 'SumY1'})
    .merge(x, how = 'right', on = 'Id')
    .assign(X1Y1 = lambda df: df.SumY1 * df.X1)
    .loc[:, ['Id', 'X1Y1']])

## @knitr morejoins3.3
(x.loc[:, ['Id', 'X1']]
    .assign(SqX1 = lambda df: df.X1**2)
    .merge(y, how = 'right', on = 'Id')
    .loc[:, list(y.columns) + ['SqX1']])

## @knitr morejoins4.3
pass

## @knitr morejoins5.3
pass

## @knitr morejoins6.3
z = pd.DataFrame(
  {"ID" : ['C', 'C', 'C', 'C', 'C'],
   "Z1" : [5, 6, 7, 8, 9],
   "Z2" : ['z5', 'z6', 'z7', 'z8', 'z9']})
x = x.assign(X2 = 'x' + x.X1.astype(str))
#
pd.merge(x, z, how = 'right', left_on = 'X1', right_on = 'Z1')
pd.merge(x, z, how = 'right', left_on = ['Id', 'X1'], right_on = ['ID', 'Z1'])

## @knitr morejoins7.3
(pd.merge(x, z, how = 'right', left_on = 'Id', right_on = 'ID')
    .query('X1 <= Z1')
    .eval('X1 = Z1')
    .drop(columns = ['ID', 'Z1']))
# ?
# ?

## @knitr morejoins8.3
pass

## @knitr morejoins9.3
pass

## @knitr morejoins10.3
pass

## @knitr morejoins11.3
(pd.DataFrame([(x, y) for x in [2, 1, 1] for y in [3, 2]],
              columns = ['V1', 'V2'])
   .sort_values(['V1', 'V2']))
(pd.DataFrame([(x, y) for x in [2, 1, 1] for y in [3, 2]],
              columns = ['V1', 'V2'])
   .drop_duplicates())


## @knitr bind
## Bind ----------------------------------------------------------------

## @knitr bind1.3
x = pd.DataFrame({"V1" : [1, 2, 3]})
y = pd.DataFrame({"V1" : [4, 5, 6]})
z = pd.DataFrame({"V1" : [7, 8, 9], "V2" : [0, 0, 0]})

## @knitr bind2.3
pd.concat([x, y])
pd.concat([x, z])

## @knitr bind3.3
pass

## @knitr bind4.3
pd.concat([x, y], axis = 1)


## @knitr setOps
## Set operations -------------------------------------------------------

## @knitr setOps1.3
pass

## @knitr setOps2.3
pass

## @knitr setOps3.3
pass

## @knitr setOps4.3
pass


