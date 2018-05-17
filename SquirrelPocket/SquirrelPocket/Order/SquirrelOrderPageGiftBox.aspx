<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="SquirrelOrderPageGiftBox.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Order.SquirrelOrderPageGiftBox" %>

<%@ Register Src="~/UCOrder/SquirelOrderGiftBox.ascx" TagPrefix="uc1" TagName="SquirelOrder" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentBody" runat="server">
    <uc1:SquirelOrder runat="server" ID="SquirelOrder" />
</asp:Content>
