<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="CartPage.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Order.CartPage" %>

<%@ Register Src="~/UCOrder/Cart.ascx" TagPrefix="uc1" TagName="Cart" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBody" runat="server">
    <uc1:Cart runat="server" id="Cart" />
</asp:Content>