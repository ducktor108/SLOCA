<%-- 
    Document   : topKNextPlaces
    Created on : Oct 9, 2014, 2:51:50 PM
    Author     : g3t2
--%>

<%@page import="sloca.model.LocationLookupDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="sloca.model.User"%>
<%@ include file = "protect.jsp" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="shortcut icon" href="CSS/assets/ico/favicon.png">
        <link href ="CSS/assets/css/docs.css" rel="stylesheet" type="text/css">


        <title>Top-k next places</title>

        <!-- Bootstrap core CSS -->
        <link href="CSS/dist/css/bootstrap.css" rel="stylesheet">
        <link href="navbar.css" rel="stylesheet">

    </head>
    <body background="img/tete.jpg">




        <div class="container">
            <div class="container">
                <img src="img\name.jpg" width="600"/>  
                <!-- Static navbar -->
                <div class="navbar navbar-default">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand">Welcome, <%=user.getName()%></a>
                    </div>
                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li><a href="home.jsp">Home</a></li>
                            <li><a href="heatMap.jsp">Heat Map</a></li>
                            <!--<li><a href="basicLocationReport.jsp">Basic Location Report</a></li>-->
                            <li class="dropdown active">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Basic Location Report <span class="caret"></span></a>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="breakDown.jsp">Breakdown by year and gender</a></li>
                                    <li><a href="popularPlace.jsp">Top-k popular places</a></li>
                                    <li><a href="popularCompanions.jsp">Top-k companions</a></li>
                                    <li><a href="topKNextPlaces,jsp">Top-k next places</a></li>
                                </ul>
                            </li>
                            <li ><a href="automaticGroupIdentification.jsp">Automatic Group Identification</a></li>
                            <!--<li><a href="groupAwareLocationReport.jsp">Group-aware Location Reports</a></li>-->
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Group-aware Location Reports <span class="caret"></span></a>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="groupPop.jsp">Top-k popular places for groups</a></li>
                                    <li><a href="groupPopNext.jsp">The top K next places for groups</a></li>
                                </ul>
                            </li>
                            <li><a href="LogoutServlet">Logout</a></li>

                        </ul>

                    </div>
                </div>
            </div>

            <!--Initializing Bootstrap--> 
            <script src="https://code.jquery.com/jquery-1.11.0.min.js"></script>
            <script src="https://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
            <br/>
            <div class ="universalform">
                <p align="center">
                    <span style="color: rgb(31, 73, 125); font-family: Aharoni; font-style: normal; font-variant: normal; letter-spacing: normal; line-height: 28px; orphans: auto; text-align: center; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; display: inline !important; float: none;">
                        <font size="4"> Top-K Next place(s)</font></span></p>
                        <% ArrayList<String> semanticPlaces = LocationLookupDAO.retrieveAllSemanticPlaces();
                            String time = (String) request.getAttribute("time");
                            String k = (String) request.getAttribute("k");
                            String ori = (String) request.getAttribute("ori");
                            if (time != null && k != null) {
                                int kk = Integer.parseInt(k);
                        %>
                <form action='ProcessTopNextPlaces.do' method='post' align="center">
                    Choice the K value:<select name='kValue'>
                        <%
                            for (int i = 1; i < 11; i++) {
                                if (i == kk) {
                                    out.println("<option selected='selected'>" + i + "</option>");
                                } else {
                                    out.println("<option>" + i + "</option>");
                                }
                            }
                        %>
                    </select><br/><br/>
                    Date and Time (dd/mm/yyyy HH:MM AM):
                    <input type='datetime-local' name='dateTime' value=<%=time%>><br>
                    <br/>
                    The origin: <select name='origin'>
                        <%for (String curr : semanticPlaces) {%>
                        <%if (curr.equals(ori)) {%>
                        <option selected='selected'><%= curr%></option>
                        <%} else {%>
                        <option><%= curr%></option>
                        <% }
                            } %>
                    </select>
                    <br/><br/>
                    <input class="btn btn-lg btn-primary btn-block" type="submit">
                </form>            
            </div>
            <%
            } else {
            %>
            <form action='ProcessTopNextPlaces.do' method='post' align="center">
                Choice the K value:<select name='kValue'>
                    <option>3</option>
                    <option>1</option>
                    <option>2</option>
                    <option>4</option>
                    <option>5</option>
                    <option>6</option>
                    <option>7</option>
                    <option>8</option>
                    <option>9</option>
                    <option>10</option>
                </select><br/><br/>
                Date and Time (dd/mm/yyyy HH:MM AM):
                <input type='datetime-local' name='dateTime' required><br>
                <br/>
                The origin: <select name='origin'>
                    <%for (String curr : semanticPlaces) {%>
                    <option><%= curr%></option>
                    <% } %>
                </select>
                <br/><br/>
                <input class="btn btn-lg btn-primary btn-block" type="submit">

            </form> 
            <%
                }
                String timeErr = (String) request.getAttribute("error");
                if (timeErr != null) {
                    out.println("<p class ='error'>" + timeErr + "</p>");
                }
            %>
            <div class="results">
                <div class="col-xs-12 col-md-7">
                    <%
                        ArrayList<String> result = (ArrayList<String>) request.getAttribute("output");
                        String count1 = (String) request.getAttribute("count1");
                        String count2 = (String) request.getAttribute("count2");
                        if (result != null) {%>
                    Number of people at the origin: <%= count2%></br>
                    Number of people who visited other places: <%= count1%>
                    </br></br></br>
                    <table class="table table-striped" border = 1 align="left">
                        <tr class="danger">
                            <th> Rank </th>
                            <th> Location </th>
                            <th> Number of People </th>
                            <th> Percentage </th>
                        </tr>
                        <%  if (result.isEmpty()) { %>
                        <tr class="active"><td colspan =4>No data available for this time slot</td></tr><br>
                        <%  } %>
                        <% for (String currLine : result) {
                                String[] arr = currLine.split(",");
                        %>
                        <tr class="active">
                            <% for (String curr : arr) {%>
                            <td>
                                <%= curr%>
                            </td>
                            <% } %>
                        </tr>
                        <%
                            } %>   
                    </table>
                    <br/>
                    <% }%>   
                </div>
            </div>
        </div>
    </body>
</html>
