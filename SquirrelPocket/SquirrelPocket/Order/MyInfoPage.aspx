<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="MyInfoPage.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Order.MyInfoPage" %>

<%@ Register Src="~/UCOrder/MyInfo.ascx" TagPrefix="uc1" TagName="MyInfo" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentBody" runat="server">
    <uc1:MyInfo runat="server" id="MyInfo" />
</asp:Content>