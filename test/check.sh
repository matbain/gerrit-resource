#!/bin/sh

set -ex

source $(dirname $0)/helpers.sh

it_can_check_from_head() {
  local private_key_path=$TMPDIR/private-key
  cat > $TMPDIR/private-key <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA8Tm6lE59fKztkeRba/aTjyXXL51Nwmj7hA/XqPOd0j9j7yTX
FP+aDerN0eAjDOtYGkzE2isEFMPPTBpjK4jWU37+ofPIHXIynec4RxJWg03FZg+j
knwJSmHQjGZecAHeQl03T4mW7C3n/IQgxp8QJ7J6f/Jdvod8tvjmQyQNR4A17+Bm
M+8VxAN2/rqzTr5oI1D6lr36oom5b//szuZsjulE4krFxtOejzamWuRQEaMoHW5W
GKksZRzE+uc/m6ZEFIl4/19ypx1TBPK+UOrnA8KIjjraABCn28Orqk1SFLmYTaw1
QceQVnFWVDfwT5OTEnuMMhOCjB3aFWkiJBfMZwIDAQABAoIBAQDr+CnRG/rbNBpt
hbH8qcds13pppHpFfAbWB91R84Xl/oaWkDYp32Nmy9MsxBHleG7Fw2UpebzTRzyI
WKO8GW53XRpfeKbAT06+ckn2FDU22qQIE7JSAC3iak7kmNs2vE0cJC2QC6rsPHfb
57BcO4tFGe2FLaSQVd8k6dPtx92JmzZ4ZdrhE3YNF3BKdez5INlXoHkbJw6bvK7e
3VFDks8kls+/329He9NHnSw5QlAw0Htb+33gZ+90nIYtgQG2uKjh2dlMWROyZq7b
X8ss0kKsY8gfTwKyEu7KSTiCKp9h7MeXM8K5RX+gM81I8iCZOlN8MDY5n8xjeJtW
9CCNcs7hAoGBAPk2WpowdMSVcrhZWyG5Qb/WLK0rt3RV/3PlX/Z8xYwopVv3jx83
KzVCHzABRILc6kQW7V2+EWWRGNuGpsMmeenG99wFNCYH950i+ProgG38PR+R2Lgl
gIZi9LxmAR2JKsEPWWUyLF3xyvFDWZ1xzZHHS+Fpj1A3c6KnVzX+UxKRAoGBAPfL
r7htXjuBLcJ/9MfkJ1dB6OBu5O1Bp0u4hZ1TJ4W6cjKYwYIPRagOdumSdxvtZ64q
0pFWde5NgilouQk2CQjT5ahPI5B10PEbCjN8jUeOFxJsyIqz7ie4a4JAO2lijRkC
8nwvBhpqSmjVHddiGK1qHFmxq9Q85sIXcI8q5vt3AoGBAOipzyJ+tLVHlWf4vHUa
oQC5stIlq0uocirAbbwQttnopKDc2bjZ57P8PGOz+0N1fhz9jrPjHBjHwv5Iku5E
wLL5+DNohEwxSgJhQTP21thYErSjlEIvePN99WDilo39nnXJn7szgWpfsAlYyJSO
R86e0v/qbksEyieDtY8KFoKRAoGAUU6EWf+I6/13Blr19qDmR7tYrku00iS4wB/L
t9ORJFAJKJD27bYVJQ+Z9QoaCw/a9UsXzJiSGZ9VFkFGdb9FN6BPuuo8wSnnZTV6
I2q68L+u0lzfcKOZgW8B17s7w1iS86ID7rt/RSubPsqu//0wG7a1lri1qO5SyVzn
khKBuAECgYBhtZ/NgvENR1swjHtdH3wDdSZEfgatM4KDvpsRFmmQ1/VOoUYEJC9e
SwFv3la35Vxvq7lp/u2ghTGrIZw5pKU6J5WjrHvQj1gz8Uwm7Qk3inF8N1/FHK38
vWXXjZIG5w5Ik6NjO8/B5GTfCR14j7jqfis9IDvg/RknVtuFAokjng==
-----END RSA PRIVATE KEY-----
EOF
  load_pubkey $private_key_path

  local repo=$(init_repo)
  local ref=$(make_commit $repo)
  local project="demo-project"
  local username="malston"

  check_gerrit_resource $repo "192.168.99.100" $project $username $private_key_path | jq -e "
    . == [{ref: $(echo $ref | jq -R .)}]
  "
}

run it_can_check_from_head
