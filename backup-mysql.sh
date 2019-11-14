#!/bin/bash


source /home/creative/Downloads/Mysql-bkp-nas-master/bkp-mysql.conf

function @CRIAPASTADIARIA () {
        echo " Criando Pasta Diaria $DATA" >> $LOG
        mkdir -p $MYSQL/$DATA
	}


function @BACKUPMYSQL () {

      HORAINIBKP=`date +%H:%M`
      echo " Efetuando DUMP da base $BASE... $HORAINIBKP" >> $LOG
      $DUMP --host=$HOST --user=$USER --password=$SENHA --databases $BASE > $MYSQL/$DATA/${BASE}_${DATA}.sql
      HORAFIMBKP=`date +%H:%M`
      echo " Dump Efetuado Com sucesso da Base $BASE... $HORAFIMBKP " >> $LOG
       # Pega Hora

    }

function @ZIPDUMP() {
    HORAZIPDUMP=`date +%H:%M`
    echo " Compactando Dump... $BASE...$HORAZIPDUMP " >> $LOG
    cd $MYSQL >> $LOG
    tar -czf ${BASE}_${DATA}.tar $DATA/ >> $LOG
    gzip -9 ${BASE}_${DATA}.tar >> $LOG
    rm -rf $DATA >> $LOG
    HORAFIMZIPDUM=`date +%H:%M` # Pega Hora
    echo " Dump Base Compactado...$HORAFIMZIPDUM" >> $LOG
    echo " Arquivo Esta em... $MYSQL" >> $LOG
}

function @RETENTIONBKP() {

    echo " Verificando Backups Antigos" >> $LOG
    find /home/ubuntu/mysql-dumps/bkp-diario* -ctime +5 -exec rm -rf {} \; >> $LOG
    echo "Limpando Arquivos LOG Antigos" >> $LOG
    find /home/ubuntu/mysql-dumps/logs* -ctime +5 -exec rm -rf {} \; >> $LOG
    echo "Dumps e Logs Antigos Com +7 Dias deletados de... $MYSQL" >> $LOG


}

@CRIAPASTADIARIA
@BACKUPMYSQL
@ZIPDUMP
@RETENTIONBKP
