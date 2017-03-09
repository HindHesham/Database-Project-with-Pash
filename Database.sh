#!bin/bash

function createDB(){
  echo "Enter Database Name: "
  read dbName
  cd $PWD
  mkdir $dbName
  if [ $? == 0 ]
  then
    echo "database created Successfully"
  else
    echo 'failed to create database'
  fi
}
function renameDB(){
  ls
  read -p "enter the old database name: " db1
	read  -p "enter the New database name: " db2
  mv $db1 $db2
  if [ $? == 0 ]
  then
	   echo "Datebase renamed Successfully"
  else
    echo "failed to rename database"
  fi
}
function deleteDB(){
  ls
  read -p "enter the name of database you want to delete: " nameDatabaseDeleted
  sudo rm  -r $nameDatabaseDeleted
  # touch $db1
   if [ $? == 0 ]
   then
     echo "database deleted "
   else
     echo "failed to delete database"
   fi
   }
function UseDb(){
  ls $PWD
	read -p "enter Database Name you want to use: " db
	cd $db
  if [ $? == 0 ]
  then
    echo "database used"
    select chioce in Table_Menu Exit
      do
        case $chioce in
           Table_Menu)
              select chioce in Create Insert Update Select Delete Exit
              do
                case $chioce in
                  Create) creatTable;;
                  Insert) insertValueIntoTable;;
                  Update) updateTable;;
                  Select) Select;;
                  Delete) Delete;;
                  Exit) exit;;
                esac
              done;;
            Exit) exit;;
        esac
      done
  else
    echo 'failed to use database'
  fi
}

function creatTable(){
  read -p "enter table name " tableName
  touch $tableName.sql
  touch $tableName.datatype
  if [ $? == 0 ]
  then
    echo 'table created!!'
  fi
  read -p "enter number of colums you want created: " noCol
  for (( i=0; i < $noCol; i=i+1 )); do
  		read -p "enter name of colum: " colName
      read -p "enter dataType of colum: " colType
      echo  -n $colName":" >> $tableName.sql
      echo  -n $colName":" >> $tableName.datatype
      echo  -n $colType":" >> $tableName.datatype
      echo ""  >> $tableName.datatype
  done
  if [ $? == 0 ]
  then
    echo 'colums created :)'
  else
    echo 'colums not created'
  fi
  echo "" >>$tableName.sql
}
function insertValueIntoTable() {
  ls *.sql
  read  -p "enter table Name :" tableName
  awk 'FNR == 1 {print}' $PWD/$tableName.sql
  read -p "enter value like the above : " value
  echo $value: >> $tableName.sql
  if [ $? == 0 ]
  then
    echo 'value inserted :)'
  else
    echo 'value not inserted'
  fi
}
function Delete() {
  select chioce in Drop_Table Delete_Row Exit
    do
      case $chioce in
          Drop_Table) deleteTable;;
          Delete_Row) deleteRow;;
          Exit) exit;;
      esac
    done
}
function deleteTable(){
  ls *.sql
  read -p "enter the name of table you want to delete: " tableNameDeleted
  rm  -r $tableNameDeleted.sql
  rm  -r $tableNameDeleted.datatype
  if [ $? == 0 ]
  then
    echo "table deleted "
  else
    echo "failed to delete table"
  fi
  }
function deleteRow() {
  ls *.sql
  read -p "enter table name you want delete from it : " tableNameSelected
  awk 'FNR == 1 {print}' $PWD/$tableNameSelected.sql
  read -p "which colum you want select: " coloumName
  feiledSelected=$(awk -F: -v coloumName=$coloumName 'BEGIN{coloumNumber=0}{if(NR==1){for(i=0;i<NF;i++){if(coloumName==$i){coloumNumber=i}}}} END{print coloumNumber}' $tableNameSelected.sql )
  read -p "enter value = " value_Condition
  # echo $value_Condition
  rowSelected=$(awk -F: '{if($'$feiledSelected'=="'${value_Condition}'"){print NR}}' $tableNameSelected.sql)
  # echo $rowSelected
  sed -i ''$rowSelected'd' $tableNameSelected.sql
  if [ $? == 0 ]
  then
    echo "row deleted "
  else
    echo "failed to delete row"
  fi
}
function Select ()
{
  select chioce in select_Table Select_Colum Select_Condition Exit
    do
      case $chioce in
          select_Table) selectAll;;
          Select_Colum) selectColoum;;
          Select_Condition) SelectCondition;;
          Exit) exit;;
      esac
    done
}
function selectAll() {
  ls *.sql
  read -p "enter table name you want selected : " tableNameSelected
  awk -F: '{print $0}' $tableNameSelected.sql
}
function selectColoum() {
  ls *.sql
  read -p "enter table name you want select from it : " tableNameSelected
  awk 'FNR == 1 {print}' $PWD/$tableNameSelected.sql
  read -p "which colum you want select .." coloumName
  failedSelected=$(awk -F: -v coloumName=$coloumName 'BEGIN{coloumNumber=0}{if(NR==1){for(i=0;i<NF;i++){if(coloumName==$i){coloumNumber=i}}}} END{print coloumNumber}' $tableNameSelected.sql)
  awk -F: -v failedSelected=$failedSelected '{ print $failedSelected }' $tableNameSelected.sql
}
function SelectCondition() {
  ls *.sql
  read -p "enter table name you want select from it : " tableNameSelected
  awk 'FNR == 1 {print}' $PWD/$tableNameSelected.sql
  read -p "which colum you want select: " coloumName
  feiledSelected=$(awk -F: -v coloumName=$coloumName 'BEGIN{coloumNumber=0}{if(NR==1){for(i=0;i<NF;i++){if(coloumName==$i){coloumNumber=i}}}} END{print coloumNumber}' $tableNameSelected.sql)
  # echo $feiledSelected
  read -p "enter value = " value_Condition
  # echo '{if($'$feiledSelected'=="'${value_Condition}'"){print $0}}'
  awk -F: '{if($'$feiledSelected'=="'${value_Condition}'"){print $0}}' $tableNameSelected.sql
}
function updateTable() {
  ls *.sql
  read -p "enter table name you want select from it : " tableNameSelected
  awk 'FNR == 1 {print}' $PWD/$tableNameSelected.sql
  read -p "which colum you want select: " coloumName
  feiledSelected=$(awk -F: -v coloumName=$coloumName 'BEGIN{coloumNumber=0}{if(NR==1){for(i=0;i<NF;i++){if(coloumName==$i){coloumNumber=i}}}} END{print coloumNumber}' $tableNameSelected.sql)
  # echo $feiledSelected
  read -p "enter value = " value_Condition
  oldData=$(awk -F: '{if($'$feiledSelected'=="'${value_Condition}'"){print $0}}' $tableNameSelected.sql)
  echo "your old data " $oldData
  read -p "enter your new data like the above : " new_Value
  sed -i 's/'$oldData'/'$new_Value'/g' $tableNameSelected.sql
  if [ $? == 0 ]
  then
    echo "row updated "
  else
    echo "failed to update row"
  fi
}
select choice in Create_DataBase Use_DataBase Renam_DataBase Delete_DataBase Exit
    do
      case $choice in
        Create_DataBase) createDB;;
        Use_DataBase) UseDb;;
        Renam_DataBase) renameDB;;
        Delete_DataBase) deleteDB;;
        Exit) exit;;
      esac
    done
