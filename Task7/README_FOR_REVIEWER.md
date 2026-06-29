# Задание 7. Аудит и обеспечение соответствия политике безопасности контейнеров (PSP / PodSecurity / OPA Gatekeeper)

1. Для проверки *admission controller* запускаем:

``` bash
./verify/verify-admission.sh
```
2. Для проверки *gatekeeper* запускаем:
``` bash
./verify/validate-security.sh
```

При выполнении скриптов поды с нарушениями отклоняются, с правильным манифестом - успешно создаются.