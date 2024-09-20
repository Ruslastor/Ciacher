import requests
from bs4 import BeautifulSoup
import re
URL = "https://programy.p.lodz.pl"#"https://programy.p.lodz.pl"

soup = BeautifulSoup(requests.get(URL).content, "html.parser")

#print(soup.prettify())

def clear_shit(s):
	return ' '.join(s.split()).replace('\n', '')

def go():



	for year in soup.find_all('button', {'class':'button'}):   #[2 : 7]

		year_parts = str(year).split('"')

		year_text = year_parts[-1][1:-13]

		year_link = year_parts[3].replace('amp;','')

		year_url = URL + '/ectslabel-web/'+year_link


		year_soup = BeautifulSoup(requests.get(year_url).content, "html.parser")

		with open(year_text.replace('/','_') + '.txt','w', encoding='utf-8') as file:
			file.write('')

		with open(year_text.replace('/','_') + '.txt', 'a', encoding='utf-8') as file:
			print(year_text)
			for program in year_soup.find_all('ul')[1:]:

				program_link = URL + str(program).split('"')[3].replace('amp;', '').replace(' ', '%20')#[2].split('/')[2]
				
				program_soup = BeautifulSoup(requests.get(program_link).content, 'html.parser')

				program_table_info = program_soup.find('div', {"class":"info"})#[0].find_all('p')
				program_table_kierunek = str(program_table_info.find('h1'))[4:-5] # !!kierunek

				program_table_row = program_table_info.find('table').find_all('tr', recursive=False)
				
				print('> ',program_table_kierunek)

				for i1 in range(0, len(program_table_row), 2):
					stopien = str(program_table_row[i1].find('p', {'class':'rotate'}))[18:-4]# !!stopień
					#print('2>> ', stopien)
					program_table_row_data = program_table_row[i1 + 1].find('tr')

					try:
						program_table_row_data_wydzial = str(program_table_row_data.find('td', {'class':'programWydzial'}).find('pre'))[5:-6]# !!wydział
					#print('3>>> ', program_table_row_data_wydzial)
						program_table_row_data_blocks = program_table_row_data.find('td', {'class':'p'}).find('table').find_all('tr', recursive=False)
						

						for i2 in program_table_row_data_blocks:
							stacjonarne_nazwa = i2.find_all('td', {'class':'p'},recursive=False)
							stacjonarne = str(stacjonarne_nazwa[0].find('p'))[3:-4]# !!stacjonarne
							#print('4>>>> ', stacjonarne)

							for i3 in stacjonarne_nazwa[1].find_all('a'):
								nazwa_link = ' '.join(str(i3).split())
								nazwa = nazwa_link.split('>')[-2][:-3]# !!nazwa
								link =  nazwa_link.split("'")[1].replace(' ', '%20').replace('amp;','')
								

								semester_soup = BeautifulSoup(requests.get('https://programy.p.lodz.pl/ectslabel-web/' + link).content, 'html.parser')

								for semester_info in semester_soup.find_all('div', {'class':'iform'}):
									
									
									if semester_info.find('div', {'class':'info'}) or semester_info.find('tr', {'class':'tabela-stopka'}):
										continue

									semester = str(semester_info.find('h3')).split('>')[-2][:-4]
									
									
									for cource_info in semester_info.find('table', {'class':'tabela'}).find_all('tr')[2:]:
										

										parts = cource_info.find_all('td')
										link_and_kod = ' '.join(str(parts[0]).split())

										link_do_przedmiotu = ''
										if parts[0].find('a'):
											kod_przedmiotu = (link_and_kod).split('>')[-3][:-3]
											link_do_przedmiotu = URL + '/ectslabel-web/'+ link_and_kod.split("'")[1].replace('amp;','').replace(' ', '%20')
										else:
											kod_przedmiotu = (link_and_kod).split('>')[-2][:-4]
										

										
										
										nazwa_przedmiotu = str(parts[1]).split('>')[1][:-4]
										
										ects, w, c, l, p, s, i, e, zal = (
											str(parts[2]).split('>')[1][:-4], 
											str(parts[3]).split('>')[1][:-4], 
											str(parts[4]).split('>')[1][:-4], 
											str(parts[5]).split('>')[1][:-4], 
											str(parts[6]).split('>')[1][:-4], 
											str(parts[7]).split('>')[1][:-4], 
											str(parts[8]).split('>')[1][:-4], 
											str(parts[9]).split('>')[1][:-4],
											' '.join((str(parts[10]).split('>')[1][:-4]).split()),
										)

										#print(link_do_przedmiotu)
										#print(program_table_row_data_wydzial)
										file.write('\t'.join([clear_shit(i) for i in [
											year_text,
											program_table_kierunek, 
											stopien, 
											program_table_row_data_wydzial, 
											stacjonarne, 
											nazwa, 
											semester,     
											kod_przedmiotu, 
											nazwa_przedmiotu, 
											ects, 
											w, c, l, p, s, i, e, zal, 
											link_do_przedmiotu
										]]) + '\n')
					except:
						print('ERROR parsing block of data')
									#print(kod_przedmiotu, nazwa_przedmiotu, ects, w, c, l, p, s, i, e, zal, sep="|")
						
				
					
				


				#program_table_is_stationary = str(program_table_info[0].find_all('p')[0])[3:-4]
				#program_table_wydzial = str(program_table_info[0].find_all('pre')[0])[5:-6]


								
go()