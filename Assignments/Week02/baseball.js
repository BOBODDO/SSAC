let random_number = [,,];
let input_number = [,,];
let howmany = 0;

//서로 다른 숫자 3개를 랜덤으로 선정
do{
    randnum();
}while(random_number[0]===random_number[1] || random_number[1]===random_number[2] || random_number[2]===random_number[0])

console.log('컴퓨터 : '+random_number[0]+random_number[1]+random_number[2]);

// 1~9사이의 랜덤한 숫자를 배열에다가 입력합니다
function randnum(){ 
    let i = 0;
    while(i < 3)
    {
        random_number[i] = Math.floor(Math.random() * 9) + 1; 
        i++;
    }
}

// 입력한 값을 받아와서 배열에 입력하고, compare함수를 실행합니다
function init()
{
    howmany++;
    if(howmany>1)
    {
        save_result(); //2회차부터 이전 결과를 저장합니다
    }
    let i=0;
    while(i<3)
    {
        input_number[i]=document.getElementById('baseball_'+(i+1)).value; // 사용자가 입력한 숫자를 가져와서 배열에다가 입력합니다
        i++;
    }
    compare();
}

// 입력한 숫자와 컴퓨터가 생성한 숫자를 비교해서 Ball,Strike를 계산합니다.
function compare()
{
    let i=0;
    let B=0;
    let S=0;
    while(i<3)
    {
        if(input_number[i]==random_number[i])
        {
            S++; // 스트라이크
        }else{in_array(input_number[i],random_number)
            B++; // 자릿수는 같지 않지만, 숫자가 존재하긴 한다면
        }
        i++;
    }
    if(S==3 && howmany<=9)
    {
        alert('승리했습니다!');
        document.getElementById('result').innerHTML = '결과 : '+B+'B'+S+'S '+howmany+'회차<font color="blue"><b>(승리)</b></font>';
        show_reset();
        

    }else if(S!=3 && howmany>8){
        alert('패배했습니다!');
        document.getElementById('result').innerHTML = '결과 : '+B+'B'+S+'S '+howmany+'회차<font color="red"><b>(패배)</b></font>';
        show_reset();
    }else{
        document.getElementById('result').innerHTML = '결과 : '+B+'B'+S+'S '+howmany+'회차';
    }

}

// number가 array내에 존재하는지 확인해서 갯수를 반환합니다
function in_array(number,array)
{
    let i=0;
    while(i<array.length)
    {
        if(number == array[i])
        {
            return 1;
        }
        i++;
    }
    return 0;
}

function show_reset()
{
    document.getElementById('try').style.display = "none";
    document.getElementById('retry').style.display = "";
}

function save_result()
{
    document.getElementById('scoreboard').innerHTML += (document.getElementById('result').innerText + '<br/>');
}