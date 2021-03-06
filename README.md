# nmap-bootstrap-xsl

A Nmap XSL implementation with Materialize.

Forked from [honze-net](https://github.com/honze-net/nmap-bootstrap-xsl).

## How to use

- Add the `nmap-bootstrap.xsl` as stylesheet to your Nmap scan. 
- Example: 

```sh
nmap -sS -T4 -A -sC -oA scanme --stylesheet https://raw.githubusercontent.com/michaelranaldo/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl scanme.nmap.org scanme2.nmap.org
```

- Open the scanme.xml with your Web browser.
- Alternatively you can transform the xml to html with

```sh
xsltproc -o scanme.html nmap-bootstrap.xsl scanme.xml
```

- You will need to download the nmap-bootstrap.xsl beforehand.

## Old scans

- You can also format old scans with the xsl stylesheet by inserting the following line after `<!DOCTYPE nmaprun>`:
    - `<?xml-stylesheet href="https://raw.githubusercontent.com/michaelranaldo/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl" type="text/xsl"?>`