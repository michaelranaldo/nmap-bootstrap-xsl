<?xml version="1.0" encoding="utf-8"?>
<!--
Nmap Bootstrap XSL
Creative Commons BY-SA
Andreas Hontzia (@honze_net)
Modified for Materialize by Michael Ranaldo (@michaelranaldo)
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
    <xsl:template match="/">
        <html lang="en">

        <head>
            <meta name="referrer" content="no-referrer" />
            <!-- Compiled and minified CSS -->
            <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css" />
            <!-- Compiled and minified JavaScript -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
            <link rel="stylesheet" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" type="text/css" />
            <script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha384-fJU6sGmyn07b+uD1nMk7/iSb4yvaowcueiQhfVgQuD98rfva8mcr1eSvjchfpMrH" crossorigin="anonymous"></script>
            <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
            <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
            <style>
            .target:before {
                content: "";
                display: block;
                height: 50px;
                margin: -20px 0 0;
            }

            @media only screen and (min-width:1900px) {
                .container {
                    width: 1800px;
                }
            }

            .footer {
                margin-top: 60px;
                padding-top: 60px;
                width: 100%;
                height: 180px;
                background-color: #f5f5f5;
            }

            .clickable {
                cursor: pointer;
            }

            .panel-heading>h3:before {
                font-family: 'Glyphicons Halflings';
                content: "\e114";
                /* glyphicon-chevron-down */
                padding-right: 1em;
            }

            .panel-heading.collapsed>h3:before {
                content: "\e080";
                /* glyphicon-chevron-right */
            }
            </style>
            <script>
            var elem = document.querySelector('.collapsible.expandable');
            var instance = M.Collapsible.init(elem, {
                accordion: false
            });

            M.AutoInit();
            </script>
            <title>Scan Report Nmap
                <xsl:value-of select="/nmaprun/@version" />
            </title>
        </head>

        <body>
            <!-- NavBar -->
            <nav>
                <div class="nav-wrapper">
                    <ul class="left hide-on-med-and-down">
                        <li><a href="#scannedhosts">Scanned Hosts</a></li>
                        <li><a href="#onlinehosts">Online Hosts</a></li>
                        <li><a href="#openservices">Open Services</a></li>
                    </ul>
                    <a href="#" data-target="side-navbar" class="sidenav-trigger"><i class="material-icons">menu</i></a>
                    <ul class="sidenav" id="side-navbar">
                        <li><a href="#scannedhosts">Scanned Hosts</a></li>
                        <li><a href="#onlinehosts">Online Hosts</a></li>
                        <li><a href="#openservices">Open Services</a></li>
                    </ul>
                    <a href="#" class="brand-logo right">Nmap Scan Report
                        <xsl:value-of select="/nmaprun/@version" /></a>
                </div>
            </nav>
            <!-- Main Content -->
            <div class="container">
                <!-- Scan Report Details Box -->
                <div class="row">
                    <h1>Scan Report</h1>
                    <h2>Nmap
                        <xsl:value-of select="/nmaprun/@version" />
                    </h2>
                    <div class="card-panel grey">
                        <pre style="white-space:pre-wrap; word-wrap:break-word;"><xsl:value-of select="/nmaprun/@args"/></pre>
                    </div>
                    <!-- The At-A-Glance Stats Bit -->
                    <div class="collection">
                        <a href="#!" class="collection-item"><span class="badge">
                                <xsl:value-of select="/nmaprun/@startstr" /></span>Scan Started
                        </a>
                        <a href="#!" class="collection-item"><span class="badge">
                                <xsl:value-of select="/nmaprun/runstats/finished/@timestr" /></span>Scan Completed
                        </a>
                        <a href="#!" class="collection-item"><span class="blue badge white-text">
                                <xsl:value-of select="/nmaprun/runstats/hosts/@total" /></span>Hosts Scanned
                        </a>
                        <a href="#!" class="collection-item"><span class="green badge white-text">
                                <xsl:value-of select="/nmaprun/runstats/hosts/@up" /></span>Hosts Up
                        </a>
                        <a href="#!" class="collection-item"><span class="red badge white-text">
                                <xsl:value-of select="/nmaprun/runstats/hosts/@down" /></span>Hosts Down
                        </a>
                    </div>
                    <!-- The Progress Bar Bit -->
                    <div class="card">
                        <div class="card-content">
                            <div class="card-title teal-text">
                                Active Hosts
                            </div>
                            <div class="card-content">
                                <p class="center"><xsl:value-of select="/nmaprun/runstats/hosts/@up div /nmaprun/runstats/hosts/@total * 100" />% of hosts up</p>
                                <div class="progress">
                                    <div class="determinate green tooltipped" data-position="top" data-tooltip="Completed Hosts" style="width: 0%">
                                        <!-- Set the width using the nmap output, overriding the default -->
                                        <xsl:attribute name="style">width:
                                            <xsl:value-of select="/nmaprun/runstats/hosts/@up div /nmaprun/runstats/hosts/@total * 100" />%;</xsl:attribute>
                                        <xsl:value-of select="/nmaprun/runstats/hosts/@up" />
                                        <span class="sr-only"></span>
                                        <!-- Set tool tip data -->
                                        <xsl:attribute name="data-tooltip">width:
                                            <xsl:value-of select="/nmaprun/runstats/hosts/@up div /nmaprun/runstats/hosts/@total * 100" />%;</xsl:attribute>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Scanned Hosts Table -->
                <div class="row">
                    <!-- If there are more than 1024 offline hosts, mention that offlines are hidden. Seems arbitrary. See Comment #1-->
                    <h2 id="scannedhosts" class="target">Scanned Hosts<xsl:if test="/nmaprun/runstats/hosts/@down > 1024"><small> (offline hosts are hidden)</small></xsl:if>
                    </h2>
                    <div class="table-responsive">
                        <table id="table-overview" class="highlight dataTable">
                            <thead>
                                <tr>
                                    <th>State</th>
                                    <th>Address</th>
                                    <th>Hostname</th>
                                    <th>Open TCP Ports</th>
                                    <th>Open UDP Ports</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:choose>
                                    <!-- Comment #1 - show every "up" host only when more than 1024 results return -->
                                    <xsl:when test="/nmaprun/runstats/hosts/@down > 1024">
                                        <xsl:for-each select="/nmaprun/host[status/@state='up']">
                                            <tr>
                                                <!-- Set the "up" state badge -->
                                                <td><span class="badge red white-text">
                                                        <xsl:if test="status/@state='up'">
                                                            <xsl:attribute name="class">badge green white-text</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="status/@state" />
                                                    </span></td>
                                                <td>
                                                    <xsl:value-of select="address/@addr" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="hostnames/hostname/@name" />
                                                </td>
                                                <!-- Consider greying out values of 0 -->
                                                <td>
                                                    <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='tcp'])" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='udp'])" />
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="/nmaprun/host">
                                            <tr>
                                                <td><span class="badge red white-text">
                                                        <xsl:if test="status/@state='up'">
                                                            <xsl:attribute name="class">badge green white-text</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="status/@state" />
                                                    </span></td>
                                                <td>
                                                    <xsl:value-of select="address/@addr" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="hostnames/hostname/@name" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='tcp'])" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='udp'])" />
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </tbody>
                        </table>
                    </div>
                    <script>
                    $(document).ready(function() {
                        $('#table-overview').DataTable();
                    });
                    </script>
                </div>
                <!-- Online Hosts Port Breakdown -->
                <div class="row">
                    <h2 id="onlinehosts" class="target">Online Hosts</h2>
                    <!-- Display details for every live host -->
                    <xsl:for-each select="/nmaprun/host[status/@state='up']">
                        <div class="card-panel">
                            <div class="panel-heading clickable" data-toggle="collapse">
                                <xsl:attribute name="data-target">#
                                    <xsl:value-of select="translate(address/@addr, '.', '-')" />
                                </xsl:attribute>
                                <h3 class="panel-title">
                                    <xsl:value-of select="address/@addr" />
                                    <xsl:if test="count(hostnames/hostname) > 0"> -
                                        <xsl:value-of select="hostnames/hostname/@name" />
                                    </xsl:if>
                                </h3>
                            </div>
                            <div class="panel-body collapse in">
                                <xsl:attribute name="id">
                                    <xsl:value-of select="translate(address/@addr, '.', '-')" />
                                </xsl:attribute>
                                <xsl:if test="count(hostnames/hostname) > 0">
                                    <h4>Hostnames</h4>
                                    <ul>
                                        <xsl:for-each select="hostnames/hostname">
                                            <li>
                                                <xsl:value-of select="@name" /> (
                                                <xsl:value-of select="@type" />)</li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>
                                <h4>Ports</h4>
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Port</th>
                                                <th>Protocol</th>
                                                <th>State<br />Reason</th>
                                                <th>Service</th>
                                                <th>Product</th>
                                                <th>Version</th>
                                                <th>Extra Info</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <xsl:for-each select="ports/port">
                                                <xsl:choose>
                                                    <xsl:when test="state/@state = 'open'">
                                                        <tr class="success">
                                                            <td title="Port">
                                                                <xsl:value-of select="@portid" />
                                                            </td>
                                                            <td title="Protocol">
                                                                <xsl:value-of select="@protocol" />
                                                            </td>
                                                            <td title="State / Reason">
                                                                <xsl:value-of select="state/@state" /><br />
                                                                <xsl:value-of select="state/@reason" />
                                                            </td>
                                                            <td title="Service">
                                                                <xsl:value-of select="service/@name" />
                                                            </td>
                                                            <td title="Product">
                                                                <xsl:value-of select="service/@product" />
                                                            </td>
                                                            <td title="Version">
                                                                <xsl:value-of select="service/@version" />
                                                            </td>
                                                            <td title="Extra Info">
                                                                <xsl:value-of select="service/@extrainfo" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="7">
                                                                <a>
                                                                    <xsl:attribute name="href">https://nvd.nist.gov/vuln/search/results?form_type=Advanced&amp;cves=on&amp;cpe_version=
                                                                        <xsl:value-of select="service/cpe" />
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="service/cpe" />
                                                                </a>
                                                                <xsl:for-each select="script">
                                                                    <h5>
                                                                        <xsl:value-of select="@id" />
                                                                    </h5>
                                                                    <pre style="white-space:pre-wrap; word-wrap:break-word;"><xsl:value-of select="@output"/></pre>
                                                                </xsl:for-each>
                                                            </td>
                                                        </tr>
                                                    </xsl:when>
                                                    <xsl:when test="state/@state = 'filtered'">
                                                        <tr class="warning">
                                                            <td>
                                                                <xsl:value-of select="@portid" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="@protocol" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="state/@state" /><br />
                                                                <xsl:value-of select="state/@reason" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@name" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@product" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@version" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@extrainfo" />
                                                            </td>
                                                        </tr>
                                                    </xsl:when>
                                                    <xsl:when test="state/@state = 'closed'">
                                                        <tr class="active">
                                                            <td>
                                                                <xsl:value-of select="@portid" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="@protocol" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="state/@state" /><br />
                                                                <xsl:value-of select="state/@reason" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@name" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@product" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@version" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@extrainfo" />
                                                            </td>
                                                        </tr>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <tr class="info">
                                                            <td>
                                                                <xsl:value-of select="@portid" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="@protocol" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="state/@state" /><br />
                                                                <xsl:value-of select="state/@reason" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@name" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@product" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@version" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="service/@extrainfo" />
                                                            </td>
                                                        </tr>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </tbody>
                                    </table>
                                </div>
                                <xsl:if test="count(hostscript/script) > 0">
                                    <h4>Host Script</h4>
                                </xsl:if>
                                <xsl:for-each select="hostscript/script">
                                    <h5>
                                        <xsl:value-of select="@id" />
                                    </h5>
                                    <pre style="white-space:pre-wrap; word-wrap:break-word;"><xsl:value-of select="@output"/></pre>
                                </xsl:for-each>
                                <xsl:if test="count(os/osmatch) > 0">
                                    <h4>OS Detection</h4>
                                    <xsl:for-each select="os/osmatch">
                                        <h5>OS details:
                                            <xsl:value-of select="@name" /> (
                                            <xsl:value-of select="@accuracy" />%)</h5>
                                        <xsl:for-each select="osclass">
                                            Device type:
                                            <xsl:value-of select="@type" /><br />
                                            Running:
                                            <xsl:value-of select="@vendor" />
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="@osfamily" />
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="@osgen" /> (
                                            <xsl:value-of select="@accuracy" />%)<br />
                                            OS CPE: <a>
                                                <xsl:attribute name="href">https://nvd.nist.gov/vuln/search/results?form_type=Advanced&amp;cves=on&amp;cpe_version=
                                                    <xsl:value-of select="cpe" />
                                                </xsl:attribute>
                                                <xsl:value-of select="cpe" />
                                            </a>
                                            <br />
                                        </xsl:for-each>
                                        <br />
                                    </xsl:for-each>
                                </xsl:if>
                            </div>
                        </div>
                    </xsl:for-each>
                </div>
                <!-- Services Breakdown -->
                <div class="row">
                    <h2 id="openservices" class="target">Open Services</h2>
                    <div class="table-responsive">
                        <table id="table-services" class="table table-striped dataTable" role="grid">
                            <thead>
                                <tr>
                                    <th>Address</th>
                                    <th>Port</th>
                                    <th>Protocol</th>
                                    <th>Service</th>
                                    <th>Product</th>
                                    <th>Version</th>
                                    <th>CPE</th>
                                    <th>Extra info</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="/nmaprun/host">
                                    <xsl:for-each select="ports/port[state/@state='open']">
                                        <tr>
                                            <td>
                                                <xsl:value-of select="../../address/@addr" />
                                                <xsl:if test="count(../../hostnames/hostname) > 0"> -
                                                    <xsl:value-of select="../../hostnames/hostname/@name" />
                                                </xsl:if>
                                            </td>
                                            <td>
                                                <xsl:value-of select="@portid" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="@protocol" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="service/@name" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="service/@product" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="service/@version" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="service/cpe" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="service/@extrainfo" />
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </div>
                <script>
                $(document).ready(function() {
                    $('#table-services').DataTable();
                });
                </script>
            </div>
            <footer class="footer">
                <div class="container">
                    <p class="grey-text">
                        This report was generated with <a href="https://github.com/honze-net/nmap-bootstrap-xsl">Nmap Bootstrap XSL</a>.<br />
                        Licensed under <a href="https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons BY-SA</a>.<br />
                        Designed and built by Andreas Hontzia (<a href="https://www.twitter.com/honze_net">@honze_net</a>).<br />
                        Modified and ported to Materialize by Michael Ranaldo (<a href="https://github.com/michaelranaldo">@michaelranaldo</a>).<br />
                    </p>
                </div>
            </footer>
        </body>

        </html>
    </xsl:template>
</xsl:stylesheet>