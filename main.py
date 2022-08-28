#LUCRUL CU FIȘIER CSV
#1. Importarea fișierului produseAlimentare_bauturi&tutun_vandute.csv folosind pachetul pandas
import pandas as pd
df = pd.read_csv('produseAlimentare_bauturi&tutun_vandute.csv', sep = ',')
pd.options.display.width= None
pd.options.display.max_columns= None
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
print(df)

lista = list(df["Produs"])
lista_strip = []
for i in lista:
 lista_strip.append(i.strip())
lista_strip.sort()
print(lista_strip)

dictionar_aparitii = {}
for i in lista_strip:
 dictionar_aparitii[i] = lista_strip.count(i)
print(dictionar_aparitii)

comenzi_BT = dictionar_aparitii.get("Banane") + dictionar_aparitii.get("Tigari Kent 8")
print("Există", comenzi_BT, "de comenzi care conțin banane şi țigări Kent 8.", sep=' ')


dict_vanzari = df.groupby("Categorie").sum()["CantitateVanduta"].to_dict()
print(dict_vanzari)


def f_discount(cantitate, pret):
    if cantitate >= 250 and cantitate < 500:
        return pret - 0.05 * pret
    elif cantitate >= 500 and cantitate < 750:
     return pret - 0.10 * pret
    elif cantitate >= 750:
     return pret - 0.15 * pret
    else:
     return pret;


print('Discount - prețul de vânzare pentru fiecare comandă:\n')
for i in df.itertuples():
    print('Cantitate vândută:', i.CantitateVanduta)
    print('Preț inițial:', i.PretTotalVanzare);
    print('Preț redus:', f_discount(i.CantitateVanduta, i.PretTotalVanzare), '\n')


lista = list(df)
for x in lista:
 if x[4] == 'Capsuni':
  print(f'Prețul căpșunilor din județul {x[1]} a fost majorat cu 25% în data de {x[0]} și a ajuns la valoarea de  :{float(x[7]) * 1.25}')
 elif x[4] == 'Struguri':
  print(f'Prețul strugurilor din județul {x[1]} a fost diminuat cu 5% în data de {x[0]} și a ajuns la valoarea de  :{float(x[7]) * 0.95}')


print(df.loc[(df['Produs']=='Chipsuri') & (df['Judet']=='Ilfov')])


lista_randuri_de_sters = df.loc[df['Produs'].isin(["Vin rose", "Coniac"])].index.values
df = df.drop(lista_randuri_de_sters, axis=0)
print(df)


for x in range(0, df.size):
 y = df.iloc[x, 0]
 if y[1] == "/":
  print(f'{y[0]}')
 else:
  print(y[0] + y[1])


print('Prețul mediu de vânzare pentru fiecare tip de produs: ')
print(df.groupby('Produs')['PretTotalVanzare'].mean())
print('\n')
print('Profitul obținut pentru fiecare categorie de produs: ')
print(df.groupby('Categorie')['ProfitImpozitat'].sum())


print('Numărul de unități vândute din fiecare produs - organizate per categorii')
print(df.groupby(['Categorie', 'Produs'])['CantitateVanduta'].sum())

print('Raport pe județe - cantitate totală vândută, prețul mediu de vânzare și profitul mediu\n')
print(df.groupby(['Judet', 'Categorie']).agg({'CantitateVanduta': sum, 'PretTotalVanzare': "mean", 'ValoareProfit': "mean"}))

print('Profitul maxim și minim obținut în urmă vânzării fiecărui produs\n')
print(df.groupby(['Produs']).agg({'ValoareProfit': [min, max]}))

import matplotlib.pyplot as plt
import pandas as pd

pd.set_option("display.max_columns", 10)
df['CantitateVanduta'].plot(kind='bar')
plt.xlabel('Profit')
plt.ylabel('CantitateVanduta')
plt.show()
