# Git 실무 - 다양한 실무 사례

## Remote에 잘못 올라간 파일/폴더를 삭제하는 방법

1. 폴더 media를 잘못 올렸다.
2. .gitignore에 'media/'를 추가하여 준다.
3. 그러나 .gitignore에 추가를 하더라도 remote에서 폴더가 삭제되지 않는다.

### LOCAL + REMOTE에서 모두 삭제하는 방법

> git rm -r media

위 명령어를 적용하고 PUSH 하면 로컬 + 리모트 모두에서 삭제 가능하다.

### LOCAL에는 남겨두고 REMOTE 에서만 삭제하는 방법

> git rm -r --cached media

위 명령어를 적용하고 PUSH 해도 리모트 에서만 삭제된다.

## Develop 브랜치가 아닌 Master 브랜치에 잘못 작업을 했을 경우

### Push는 하지 않고 LOCAL에만 반영된 경우

> git branch tmp

위 명령어를 통하여 우선 코드가 반영된 master 에서 tmp 브랜치를 생성한다.

> git reset --hard HEAD~

위 명령어를 통하여 master 브랜치를 원상복귀한다(하나의 커밋만 되돌아가기).

> git merge --no-ff tmp

다음으로, develop 브랜치로 이동하여 tmp 브랜치에 반영된 코드 변경사항을 merge 한다.

> git branch -d tmp

마지막으로, 제 역할을 다한 tmp 브랜치를 삭제한다.

### Push 까지 해서 Remote에도 반영된 경우

> git branch tmp

위 명령어를 통하여 우선 master에서 tmp 브랜치를 생성한다.

> git reset --hard HEAD~

위 명령어를 통해서 master 브랜치를 원상복귀한다.

> git push -f origin master

원상복귀한 master 브랜치를 remote에 강제로 업로드 한다(-f 옵션이 없으면 코드가 충돌되므로 업로드 되지 않는다).

> git merge --no-ff tmp

다시 develop 브랜치로 돌아가서, tmp 로부터 추가된 코드를 merge 한다.

> git branch -d tmp

마지막으로 위 명령어를 적용하여 tmp 브랜치를 삭제한다.

## 작업중에 브랜치를 실수로 삭제한 경우
topic 브랜치에서 개발을 마치고 커밋을 하고, 다시 master 브랜치로 와서 merge를 해야했다.
그런데 실수로 git branch -D topic 명령어를 통하여 'merge 하지 않음' 에 대한 경고 없이 topic 브랜치를 삭제했다고 가정해본다.

> git reflog

위 명령어를 통하여 로그를 확인하고, checkout 했던 시점의 커밋 코드를 확인한다.

> git checkout -b topic 9afcdf5

위에서 확인한 시점의 커밋 코드(9afcdf5)를 기준으로 topic 브랜치를 다시 생성한다.
주의할 점은 'git reset --hard' 로는 삭제한 브랜치가 복구되지 않고 단순히 master 의 코드만 복구된다는 것!

## 서비스를 특정 태그로 긴급 롤백이 필요한 경우
git flow 를 통해 hotfix/0.2.1 에서 긴급 버그를 수정하여 master 브랜치로 merge 하였으나,
갑자기 master 브랜치에서 오류가 발생하여 긴급하게 master 브랜치를 0.2.0으로 롤배개야 하는 경우이다.

> git branch tmp

우선 위 명령어를 통해 '버그 수정이 반영 된' master 브랜치의 코드를 브랜치를 하나 생성한다.
단순히 git reset --hard 를 적용하게 되면 '버그 수정' 내용도 모두 삭제되기 때문이다.

> git reset --hard 0.2.0

브랜치를 통해 백업을 한 이후에 master 브랜치를 0.2.0 코드로 되돌린다.

> git push origin +master

서버에도 긴급하게 반영을 한다(+ 가 붙어있으므로 -f 옵션 효과를 가진다).

> git flow hotfix start 0.2.2

위 명령어를 적용해도 hotfix/0.2.2 브랜치에는 0.2.1의 코드가 적용되지는 않는다.
hotfix의 코드는 develop(0.2.1 코드가 있음) 에서 파생되어 오는게 아니라, master 브랜치에서 파생되어 오기 때문이다.

> git merge --no-ff develop

따라서 위 명령어를 통해서 develop의 코드를 hotfix/0.2.2 코드로 가져와야 한다.

> git flow hotfix finish 0.2.2

마지막으로, 위 명령어를 통해 핫픽스 0.2.2를 마감하면 master 브랜치에 0.2.2의 코드가 반영이된다.