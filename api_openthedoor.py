#!/usr/bin/env python

import tornado.ioloop 
import tornado.web
import RPi.GPIO as GPIO
import time
import datetime
import os
import MySQLdb
import json

##### Variaveis MySQL #######
hostname="localhost"
username="openthedoor"
password="677890rTii"
database="openthedoor"
#############################


#### OK - Portao aberto COM SUCESSO
json_portaoaberto = {"codMsg": "1", "status": "OK", "msg": "Portao aberto COM SUCESSO!"}

#### ERRO - Nao e permitido a abertura do portao nos finais de semana!
json_fds = {"codMsg": "2", "status": "ERRO", "msg": "Nao e permitido a abertura do portao nos finais de semana!"}

#### ERRO - Horario nao permitido! 
json_horarionaopermitido = {"codMsg": "3", "status": "ERRO", "msg": "Horario nao permitido!"}

#### ERRO - IMEI desabilitado!
json_imeidesabilitado = {"codMsg": "4", "status": "ERRO", "msg": "IMEI Desabilitado!"}

#### ERRO - IMEI incorreto ou nao cadastrado! 
json_imeiincorreto = {"codMsg": "5", "status": "ERRO", "msg": "IMEI incorreto ou nao cadastrado!"}

#### OK - Pre Cadastro efetuado! 
json_preCadastro = {"codMsg": "7", "status": "OK", "msg": "Pre Cadastro efetuado!"}

#### OK - Pre Cadastro nao aceito!
json_preCadastroNaoAceito = {"codMsg": "9", "status": "ERRO", "msg": "Pre Cadastro ainda nao foi aceito pelo admin!"}
#############################


######### Funcoes ###########
def aciona_portao():
	GPIO.setmode(GPIO.BOARD)
	GPIO.setwarnings(False)
	GPIO.setup(7, GPIO.OUT)
	GPIO.output(7, GPIO.HIGH)
	time.sleep(1)
	GPIO.output(7, GPIO.LOW)

	return json_portaoaberto


def log(msg, ip, idCadastro, status, codMsg):
	dt_hr_log=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        ########### Consulta configuracoes no MySQL
        db = MySQLdb.connect(host=hostname,
                user=username,
                passwd=password,
                db=database)
        cur = db.cursor()
        cur.execute("""INSERT INTO logs (datahora,status,ip,id_device,msg,cod_msg) VALUES (%s,%s,%s,%s,%s,%s)""",(dt_hr_log, status, ip, idCadastro, msg, codMsg))
	db.commit()
	db.close()

def efetua_preCadastro(deviceId, email):
	dt_hr=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

	db = MySQLdb.connect(host=hostname,
                user=username,
                passwd=password,
                db=database)
        cur = db.cursor()
	cur.execute("SELECT enable FROM devices WHERE deviceId='%s'" % deviceId)
        resultado=cur.fetchone()
        ############################################
        if cur.rowcount != 1:
		cur.execute("""INSERT INTO devices (deviceId, email, enable, datahora) VALUES (%s,%s,2,%s)""",(deviceId, email, dt_hr))
	        db.commit()
        else:
        	cur.execute("""UPDATE devices SET email='%s', datahora='%s' WHERE deviceId='%s'""" % (email, dt_hr, deviceId))
        	db.commit()
        db.close()

def check_login(deviceId):
	########### Consulta configuracoes no MySQL
        db = MySQLdb.connect(host=hostname,
                user=username,
                passwd=password,
                db=database)
        cur = db.cursor()
        cur.execute("SELECT enable FROM devices WHERE deviceId='%s'" % deviceId)
	resultado=cur.fetchone()
        ############################################
	if cur.rowcount != 1:
		return "erro"
	else:
		if resultado[0] == 0:
			return "disable"
		else:
			if resultado[0] == 1:
				return "ok"	
			else:
				return "preCadastro_naoefetuado"
	db.close()		

def check_idCadastro(deviceId):
        ########### Consulta configuracoes no MySQL
        db = MySQLdb.connect(host=hostname,
                user=username,
                passwd=password,
                db=database)
        cur = db.cursor()
        cur.execute("SELECT id_device FROM devices WHERE deviceId='%s'" % deviceId)
	resultado=cur.fetchone()
        ############################################
        if cur.rowcount != 1:
                return 0
        else:
                return resultado[0]

        db.close()


###### PreCadastro
class preCadastro(tornado.web.RequestHandler):
    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with, Content-Type")
        self.set_header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS')

    def post(self):
        IP=self.request.remote_ip

        data = json.loads(self.request.body)
        POST_deviceId = str(data['deviceId'])
        POST_email = str(data['email'])

	if POST_deviceId == '' or POST_email == '':
		#### ERRO - Campos IMEI ou Email estao vazios! 
		json_erroPreCadastro = {"codMsg": "8", "status": "ERRO", "msg": "Campos IMEI ou Email estao vazios!"}
		self.write(json_erroPreCadastro)
		msg_log=json_erroPreCadastro['msg'] + " deviceId: " + POST_deviceId
		log(msg_log, IP, 0, json_erroPreCadastro['status'], json_erroPreCadastro['codMsg'])
	else:
		efetua_preCadastro(POST_deviceId, POST_email)
		idCadastro=check_idCadastro(POST_deviceId)
		self.write(json_preCadastro)
                log(json_preCadastro['msg'], IP, idCadastro, json_preCadastro['status'], json_preCadastro['codMsg'])


    def options(self, id):
        self.set_status(200, "OK")
        self.finish()


####### Abrir Portao
class MainHandler(tornado.web.RequestHandler):
    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with, Content-Type")
        self.set_header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS')  

    def post(self):
	IP=self.request.remote_ip

	data = json.loads(self.request.body)
        POST_deviceId = str(data['deviceId'])

	checkLogin=check_login(POST_deviceId)

        if checkLogin == 'erro':
		self.write(json_imeiincorreto)
		msg_log=json_imeiincorreto['msg'] + " deviceId: " + POST_deviceId
		log(msg_log, IP, 0, json_imeiincorreto['status'], json_imeiincorreto['codMsg']) 
	else:
		idCadastro=check_idCadastro(POST_deviceId)

		if checkLogin == 'disable':
			self.write(json_imeidesabilitado)
                        log(json_imeidesabilitado['msg'], IP, idCadastro, json_imeidesabilitado['status'], json_imeidesabilitado['codMsg'])
		elif checkLogin ==  'preCadastro_naoefetuado':
			self.write(json_preCadastroNaoAceito)
			log(json_preCadastroNaoAceito['msg'], IP, idCadastro, json_preCadastroNaoAceito['status'], json_preCadastroNaoAceito['codMsg'])
		else:
			hj=datetime.date.today()
			dias_semana=('Segunda-feira', 'Terca-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sabado', 'Domingo')
			dia_da_semana=dias_semana[hj.weekday()]
			datahora_now=datetime.datetime.now().strftime("%H%M")
		
		
			########### Consulta configuracoes no MySQL
			db = MySQLdb.connect(host=hostname,
			        user=username,
		        	passwd=password,
		        	db=database)
			cur = db.cursor()
			cur.execute("SELECT hr_inicial, hr_final, intervalo, bloquearfds FROM configuracoes")
			resultado=cur.fetchone()
			#############################
		
		
			#############################
			hr_inicial=resultado[0]             # Durante a semana, a partir desse horario e permitido a abertura do portao
			hr_final=resultado[1]               # Durante a semana, antes desse horario e permitido a abertura do portao
			tempo_espera_portao=resultado[2]    # Tempo de espera em segundos entre um acionamento e outro
			bloquearfds=resultado[3]            # Bloquear FDS (Sabado e Domingo)
			#############################
		
			#### ERRO - Aguardar o intervalo para abrir o portao novamente
			json_intervalo = {"codMsg": "6", "status": "ERRO", "msg": "Aguardar o intervalo de %d segundos para abrir o portao novamente!" % tempo_espera_portao}
			#############################
		
		
			# Verifica se esta setado para bloquear a abertura do portao nos Finais de Semana
			if (dia_da_semana == 'Sabado' or dia_da_semana == 'Domingo') and (bloquearfds == 'Sim' or bloquearfds == 'sim' or bloquearfds == 'SIM'):
				self.write(json_fds)
				log(json_fds['msg'], IP, idCadastro, json_fds['status'], json_fds['codMsg']) 
			else:
				if datahora_now >= hr_inicial and datahora_now <= hr_final:
					# Verifica se existe arquivo de controle de intervalo de tempo entre a abertura do portao
					if os.path.isfile("/tmp/portao_aberto"):
						time_file = os.path.getctime("/tmp/portao_aberto")
						time_now = time.time()
		
						tempo_total=time_now-time_file
		
						# Verifica se tempo entre abertura do portao eh maior que X segundos
						if tempo_total > tempo_espera_portao:
							os.system("rm -f /tmp/portao_aberto 1>/dev/null 2>/dev/null")
							
							self.write(aciona_portao())
							log(json_portaoaberto['msg'], IP, idCadastro, json_portaoaberto['status'], json_portaoaberto['codMsg'])
		
							os.system("touch /tmp/portao_aberto")
						else:	
							self.write(json_intervalo) 
							log(json_intervalo['msg'], IP, idCadastro, json_intervalo['status'], json_intervalo['codMsg'])
					else:
						os.system("touch /tmp/portao_aberto") 
						
						self.write(aciona_portao())
						log(json_portaoaberto['msg'], IP, idCadastro, json_portaoaberto['status'], json_portaoaberto['codMsg'])
				else:
					self.clear()
					self.write(json_horarionaopermitido)
					log(json_horarionaopermitido['msg'], IP, idCadastro, json_horarionaopermitido['status'], json_horarionaopermitido['codMsg'])
			db.close()

    def options(self, id):
        self.set_status(200, "OK")
        self.finish()

def portao_app():
    return tornado.web.Application([
        (r"/openTheDoor", MainHandler),
        (r"/preCadastro", preCadastro),
    ])

if __name__ == "__main__":
    app = portao_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

