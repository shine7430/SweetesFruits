<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.home" %>

<%@ Register Src="~/UCOrder/Home.ascx" TagPrefix="uc1" TagName="Home" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBody" runat="server">
    <uc1:Home runat="server" ID="Home" />

</asp:Content>
