<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="MyPage.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Order.My" %>

<%@ Register Src="~/UCOrder/My.ascx" TagPrefix="uc1" TagName="My" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBody" runat="server">
    <uc1:My runat="server" ID="My1" />
</asp:Content>

